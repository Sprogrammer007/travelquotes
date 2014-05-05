class Plan < ActiveRecord::Base
  DEFAULT_HEADER = %w{ unique_id product_id type }
  belongs_to :product

	has_many :age_sets
	has_many :age_brackets, :through => :age_sets

	has_many :plan_filter_sets
	has_many :plan_filters, :through => :plan_filter_sets

  belongs_to :detail, polymorphic: true

	accepts_nested_attributes_for :age_brackets

	#Callbacks
	after_commit :set_unique_id, unless: Proc.new { |plan| plan.unique_id } 
  
  #Scopes
  generate_scopes
  scope :active, -> {status.eq("Active")}
  scope :get_type, ->(type) {details_type_eq(type).active}

	def set_unique_id
		self.unique_id = "#{self.product.company.short_hand + self.product.product_number + self.type}"
		self.save
	end

  def get_rates(age, sum)
    age_brackets.merge(AgeBracket.include_age(age)).joins(:rates).merge(Rate.with_sum_insured(sum)).select("rates.rate as rate")
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

	def self.get_types
		%w{ Visitor SuperVisa AllInclusive}
	end

  self.inheritance_column = :race 
end
