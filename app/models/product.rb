class Product < ActiveRecord::Base

  DEFAULT_HEADER = %w{company_id name policy_number description min_price 
    can_buy_after_30_days can_renew_after_30_days renewable_max_age
    preex preex_max_age preex_based_on_sum_insured status purchase_url 
    rate_effective_date future_rate_effective_date effective_date }
  
  belongs_to :company
  has_many :deductibles
  has_many :legal_texts
  has_many :versions, :dependent => :destroy
  has_many :age_brackets
  has_many :product_filter_sets
  has_many :product_filters, :through => :product_filter_sets

  accepts_nested_attributes_for :versions
  accepts_nested_attributes_for :deductibles
  
  delegate :logo, to: :company
  
  validates :name, :company_id, :min_price, :renewable_max_age, :preex_max_age, :purchase_url, :rate_effective_date, :effective_date, presence: true
  validates :min_price, :preex_max_age, :renewable_max_age, numericality: { only_integer: true }
  validates :preex, :preex_based_on_sum_insured, :can_renew_after_30_days, :can_buy_after_30_days, :status, inclusion: { in: [true, false] }
  
  #scopes
  generate_scopes
  scope :has_preex, -> { preex_eq(true) }
  scope :has_no_preex, -> { preex_eq(false) }
  scope :active, -> { status_eq(true)}
  scope :can_buy_after_30, -> { can_buy_after_30_days_eq(true) }
  scope :renewable_after_30, -> {  can_renew_after_30_days_eq(true) | can_buy_after_30_days_eq(true) }

  def get_deductible
    f = []
    deductibles.each do |d|
      f << [d.amount, d.mutiplier]
    end
    return f
  end

  def legal_texts_sorted

  end
  
  def self.find_compare(ps)
    products = []
    ps.each_value do |v| 
      product = find(v["id"])
      product.define_singleton_method(:rate) do
        v["rate"]
      end
      products << product
    end
    return products
  end


end
