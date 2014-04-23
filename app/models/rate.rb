class Rate < ActiveRecord::Base
  DEFAULT_HEADER = %w{age_bracket_id product_id sum_insured preex effective_date rate}

  belongs_to :age_bracket
  belongs_to :product

  scope :has_pre_existing_medicals, -> { where(:preex => true) }
  def self.select_age_bracket_options
  	h = Hash.new 
  	Product.all.map do |product| 
  		h[product.name] =  product.plans.map { |plan| plan.age_brackets.map {|age| [plan.type + " (#{age.range})", age.id]}}.flatten(1)
  	end
  	h
  end
end
