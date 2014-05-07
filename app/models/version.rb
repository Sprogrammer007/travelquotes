class Version < ActiveRecord::Base

  DEFAULT_HEADER = %w{product_id type detail_type detail_id status}
  belongs_to :product

	has_many :age_sets
	has_many :age_brackets, :through => :age_sets

  belongs_to :detail, polymorphic: true

	accepts_nested_attributes_for :age_brackets
  accepts_nested_attributes_for :detail

  #Scopes
  generate_scopes
  scope :active, -> {status_eq(true)}
  scope :with_type, ->(type) {detail_type_eq(type).active}
  scope :family, -> {detail_type_eq("FamilyDetail")}
  scope :couple, -> {detail_type_eq("CoupleDetail")}
  scope :single, -> {detail_type_eq("SingleDetail")}

  delegate :has_special_rate?, to: :detail

  def get_rates(age, sum)
    age_brackets.merge(AgeBracket.include_age(age)).joins(:rates).merge(Rate.include_sum(sum)).select("rates.rate as rate")
  end

	#This is a fix for destroy related agebrackets for the plans that are not
  #tied to other plans. 
  def destroy_related
  	ages = []
	 	ids = self.age_brackets.pluck(:id)
 			ids.each do |id|
 				agesets = AgeSet.where(age_bracket_id: id)
				ages << agesets[0] 	if agesets.any? && agesets.count == 1
			end
	 	ages.each { |age| age.destroy }
	 	self.destroy 
  end

  def detail_type
    super.gsub("Detail", "") if super
  end

	def self.get_types
		%w{ Visitor Super\ Visa Visitor\ and\ Super\ Visa}
	end

  self.inheritance_column = :race 
end
