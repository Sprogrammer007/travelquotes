class AgeBracket < ActiveRecord::Base
	DEFAULT_HEADER = %w{product_id range min_age max_age}
	
	belongs_to :product
	has_many :age_sets
	has_many :plans, :through => :age_sets 
	has_many :rates, :dependent => :destroy
	accepts_nested_attributes_for :rates
	#Callbacks
	after_commit :set_range_product, unless: Proc.new { |age| age.product } 

	def set_range_product
		self.range = "#{self.min_age} - #{self.max_age}"
		self.product_id = self.plans[0].product_id
		self.save
	end

	def self.product_selection
		Hash[Product.all.map {|pro| [ pro.name, pro.plans.map {|p| [p.type, p.id]} ]}]
	end

	def self.plans_filter_selection
		Hash[Product.all.map {|pro| [ pro.name, pro.plans.map {|p| [pro.name + " (#{p.type})", p.id]} ]}]
	end
end
