class Deductible < ActiveRecord::Base
  DEFAULT_HEADER = %w{product_id amount mutiplier}

  belongs_to :product

  # scopes
  generate_scopes
  scope :amount_of, ->(a, b) {amount_gteq(a) & amount_lteq(b)}
  scope :no_deductible, -> {amount_eq(0)}
  scope :age_between, ->(age) {min_age_lteq(age) & max_age_gteq(age)}

  validates :amount, :mutiplier, :product_id, presence: true
  validates :amount, :numericality => {:only_integer => true}
  validates :mutiplier, :numericality => {:only_integer => false}
  
  def self.deductible_eq(range)
    if range == "0"
      no_deductible
    else
      r = range.gsub(" ", "").split("-").map(&:to_i).minmax
      amount_of(r[0], r[1])
    end
  end

  # Not In Use
  # def self.conditions_options
  #   [["Not Applicable"], ['Greater', 'gt'], ['Lesser', 'lt'], 
  #   ['Greater and Equal', 'gteq'], ['Lesser and Equal', 'lteq']]
  # end

end
