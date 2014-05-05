class Rate < ActiveRecord::Base
  DEFAULT_HEADER = %w{age_bracket_id rate rate_type sum_insured  effective_date status}

  belongs_to :age_bracket

  before_save :set_status

  #scopes
  generate_scopes

  scope :current, -> { where("status = ? AND effective_date < ?", "Current", Date.today) }
  scope :outdated, -> { where("status = ? AND effective_date < ?", "OutDated", Date.today) }
  scope :future, -> { where("status = ? AND effective_date > ?", "Future", Date.today) }
  scope :with_sum_insured, ->(sum) {sum_insured_eq(sum).current}

  def set_status
    unless self.status
      self.status = self.effective_date > Date.today ? "Future" : "Current"
    end
  end
  
  def self.select_age_bracket_options
  	h = Hash.new 
  	Product.all.map do |product| 
  		h[product.name] =  product.plans.map { |plan| plan.age_brackets.map {|age| [plan.type + " (#{age.range})", age.id]}}.flatten(1)
  	end
  	h
  end

  def self.rate_types
    %w{Daily Weekly Monthly Annually}
  end

  def self.status
    %w{Current OutDated Future}
  end
end
