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
  
  validates :name, :company_id, :renewable_max_age, :preex_max_age, :purchase_url, :rate_effective_date, :effective_date, presence: true
  validates :min_price, :preex_max_age, :renewable_max_age, numericality: { only_integer: true }
  validates :preex, :preex_based_on_sum_insured, :can_renew_after_30_days, :can_buy_after_30_days, :status, inclusion: { in: [true, false] }
  
  #PDF
  has_attached_file :pdf
  validates_attachment :pdf, :content_type => { :content_type => "application/pdf" }

  #scopes
  generate_scopes
  scope :has_preex, -> { preex_eq(true) }
  scope :no_preex, -> { preex_eq(false) }
  scope :active, -> { status_eq(true)}
  scope :can_buy_after_30, -> { can_buy_after_30_days_eq(true) }
  scope :renewable_after_30, -> {  can_renew_after_30_days_eq(true) | can_buy_after_30_days_eq(true) }
  scope :policy_type_of, -> (t) { policy_type_eq(t) }

  def get_deductible_by_age(age)
    f = []
    deductibles.age_between(age).order("amount ASC").each do |d|
      f << [d.amount, d.mutiplier]
    end
    return f
  end

  def self.find_compare(ps)
    products = []
    ps.each_value do |v| 
      product = find(v["id"])
      product.define_singleton_method(:applied_ded) do
        v["ded_value"]
      end
      product.define_singleton_method(:rate) do
        (v["rate"].to_f * v["ded_mutip"].to_f)
      end
      products << product
      products.sort_by! { |p| p.id }
    end
    return products
  end

  private
    attr_reader :applied_lts
  

end
