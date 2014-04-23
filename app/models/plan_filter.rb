class PlanFilter < ActiveRecord::Base
	DEFAULT_HEADER = %w{product_id category name description}
	belongs_to :product
  has_many :plan_filter_sets
  has_many :plans, :through => :plan_filter_sets
 	


 	def self.plans_filter_selection
		Hash[Product.all.map {|pro| [ pro.name, pro.plans.map {|p| [pro.name + " (#{p.type})", p.id]} ]}]
	end
end
