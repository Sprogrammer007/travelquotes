class AgeBracket < ActiveRecord::Base
	DEFAULT_HEADER = %w{product_id min_age max_age 
		min_trip_duration max_trip_duration preex}
	
	belongs_to :product
	has_many :age_sets
	has_many :versions, :through => :age_sets 
	has_many :rates, :dependent => :destroy
	accepts_nested_attributes_for :rates
	
	#Callbacks
	before_save :set_preex

	#scopes
	generate_scopes
	scope :include_age, ->(age) {min_age_lteq(age) & max_age_gteq(age)}
	scope :preex, -> {preex_eq(true)}

<<<<<<< HEAD
=======
	validates :min_age, :max_age, :min_trip_duration, :max_trip_duration, :product_id,  presence: true
  validates :min_age, :max_age, :min_trip_duration, :max_trip_duration, :numericality => {:only_integer => true}

>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
	def self.product_selection
		Hash[Product.all.map {|pro| [ pro.name, pro.versions.map {|v| [v.detail_type, v.id]} ]}]
	end

	def self.versions_filter_selection
		Hash[Product.all.map {|pro| [ pro.name, pro.versions.map {|v| [pro.name + " (#{v.detail_type})", v.id]} ]}]
	end

	def range
		"#{self.min_age} - #{self.max_age}"
	end
	
	private
		
		def set_preex
			if self.new_record?
				self.preex = self.product.preex
			end
		end

end
