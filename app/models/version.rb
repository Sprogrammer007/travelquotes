class Version < ActiveRecord::Base

  DEFAULT_HEADER = %w{product_id type detail_type detail_id status}
  belongs_to :product

	has_many :age_sets, dependent: :destroy
	has_many :age_brackets, :through => :age_sets

  belongs_to :detail, polymorphic: true, dependent: :destroy

	accepts_nested_attributes_for :age_brackets
  accepts_nested_attributes_for :detail

  delegate :product_filters, :logo, to: :product

  #Scopes
  generate_scopes
  scope :active, -> {status_eq(true)}
  scope :with_type, ->(type) {detail_type_eq(type).active}
  scope :family, -> {detail_type_eq("FamilyDetail")}
  scope :couple, -> {detail_type_eq("CoupleDetail")}
  scope :single, -> {detail_type_eq("SingleDetail")}

  validates :product_id, :type, presence: true

  delegate :has_special_rate?, to: :detail

  def get_rates(age, sum)
    age_brackets.merge(AgeBracket.include_age(age)).joins(:rates).merge(Rate.include_sum(sum)).select("rates.rate as rate")
  end

	#This is a fix for destroy related agebrackets for the plans that are not
  #tied to other plans. 
  def destroy_related
  	destroyable_ages = []
	 	age_bracket_ids = self.age_brackets.pluck(:id)
 			age_bracket_ids.each do |id|
 				agesets = AgeSet.where(age_bracket_id: id)
        if agesets.any? && agesets.count == 1
          destroyable_ages << agesets
        end
			end
	 	destroyable_ages.each { |age| age.age_bracket.destroy }
	 	self.destroy 
  end

  def detail_type
    super.gsub("Detail", "") if super
  end

	def self.get_types
		%w{ Visitor Super\ Visa Visitor\ and\ Super\ Visa}
	end

  self.inheritance_column = :race 

  #Adding agebracket to family and couple version automatically if no special rate is specified
  def add_age_bracket
    unless self.has_special_rate?
      single_version = self.product.versions.where(:detail_type => "SingleDetail")
      if single_version.any?
        age_bracket_ids = AgeSet.where(:version_id => single_version.first.id).pluck(:age_bracket_id).map { |i| {:age_bracket_id => i }}
        if age_bracket_ids.any?
          AgeSet.create(age_bracket_ids) do |a|
            a.version_id = self.id
          end
        end
      end
    end
  end

end
