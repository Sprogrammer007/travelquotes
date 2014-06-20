class Rate < ActiveRecord::Base
  DEFAULT_HEADER = %w{age_bracket_id rate rate_type sum_insured  effective_date status}

  belongs_to :age_bracket

  before_save :set_status

  #scopes
  generate_scopes

  scope :current, -> { status_eq("Current") }
  scope :outdated, -> { status_eq("Outdated")}
  scope :future, -> { status_eq("Future") }
  scope :include_sum, ->(sum) {sum_insured_eq(sum).current}

  validates :rate, :rate_type, :sum_insured,  presence: true
  validates :rate, :numericality => {:only_integer => false}
  validates :sum_insured,  :numericality => {:only_integer => true}

  def set_status
    set_effective_date()
    unless self.status
      self.status = (self.effective_date > Date.today)? "Future" : "Current"
    end
  end
  
  def set_effective_date
    unless self.effective_date
      self.effective_date = self.age_bracket.product.rate_effective_date
    end
  end
  def self.select_age_bracket_options
  	h = Hash.new 
  	Product.all.map do |product| 
  		h[product.name] =  product.versions.map { |version| version.age_brackets.map {|age| [version.detail_type + " (#{age.range})", age.id]}}.flatten(1)
  	end
  	h
  end

  def self.rate_types
    %w{Daily Weekly Monthly Annually}
  end

  #not in use
  def self.status
    %w{Current OutDated Future}
  end

  def self.update_future_rate
    puts "cron updating future rate"
  end
end
