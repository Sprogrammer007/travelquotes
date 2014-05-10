class Product < ActiveRecord::Base

  DEFAULT_HEADER = %w{company_id name product_number description min_price 
    can_buy_after_30_days renewable renewable_period renewable_max_age
    preex preex_max_age follow_ups status purchase_url effective_date }
  
  belongs_to :company
  has_many :deductibles
  has_many :legal_texts
  has_many :versions, :dependent => :destroy
  has_many :age_brackets
  has_many :product_filter_sets
  has_many :product_filters, :through => :product_filter_sets

  accepts_nested_attributes_for :versions
  
  delegate :logo, to: :company
  
  #scopes
  generate_scopes
  scope :has_preex, -> { preex_eq(true) }
  scope :has_no_preex, -> { preex_eq(false) }
  scope :active, -> { status_eq(true)}
end
