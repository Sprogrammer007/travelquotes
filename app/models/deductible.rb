class Deductible < ActiveRecord::Base
<<<<<<< HEAD
  DEFAULT_HEADER = %w{product_id amount mutiplier condition }

  belongs_to :product

=======
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
    [['Greater', 'gt'], ['Lesser', 'lt'], 
    ['Greater and Equal', 'gteq'], ['Lesser and Equal', 'lteq']]
  end
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232

end
