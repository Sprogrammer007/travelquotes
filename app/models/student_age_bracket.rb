class StudentAgeBracket < ActiveRecord::Base
  DEFAULT_HEADER = %w{student_product_id min_age max_age 
    min_trip_duration max_trip_duration preex}
  
  belongs_to :student_product
  has_many :student_age_sets
  has_many :student_versions, :through => :student_age_sets 
  has_many :student_rates, :dependent => :destroy
  accepts_nested_attributes_for :student_rates
  
  #Callbacks
  before_save :set_preex

  #scopes
  generate_scopes
  scope :include_age, ->(age) {min_age_lteq(age) & max_age_gteq(age)}
  scope :preex, -> {preex_eq(true)}

  validates :min_age, :max_age, :min_trip_duration, :max_trip_duration, :student_product_id,  presence: true
  validates :min_age, :max_age, :min_trip_duration, :max_trip_duration, :numericality => {:only_integer => true}

  def self.product_selection
    Hash[StudentProduct.all.map {|pro| [ pro.name, pro.student_versions.map {|v| [v.detail_type, v.id]} ]}]
  end

  def self.versions_filter_selection
    Hash[StudentProduct.all.map {|pro| [ pro.name, pro.student_versions.map {|v| [pro.name + " (#{v.detail_type})", v.id]} ]}]
  end

  def range
    "#{self.min_age} - #{self.max_age}"
  end
  
  private
    
    def set_preex
      if self.new_record?
        self.preex = self.student_product.preex
      end
    end
end
