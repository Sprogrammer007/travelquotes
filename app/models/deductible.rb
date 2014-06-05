class Deductible < ActiveRecord::Base
  DEFAULT_HEADER = %w{product_id amount mutiplier condition age}

  belongs_to :product

  # scopes
  generate_scopes
  scope :amount_of, ->(a, b) {amount_gteq(a) & amount_lteq(b)}
  scope :no_deductible, -> {amount_eq(0)}

  validates :amount, :mutiplier, :condition, :age, :product_id, presence: true
  validates :amount, :age, :numericality => {:only_integer => true}
  validates :mutiplier, :numericality => {:only_integer => false}
  
  def self.deductible_eq(range)
    if range == "0"
      no_deductible
    else
      r = range.gsub(" ", "").split("-").minmax
      amount_of(r[0].to_i, r[1].to_i)
    end
  end

  def self.conditions_options
    [["Not Applicable"], ['Greater', 'gt'], ['Lesser', 'lt'], 
    ['Greater and Equal', 'gteq'], ['Lesser and Equal', 'lteq']]
  end

end
