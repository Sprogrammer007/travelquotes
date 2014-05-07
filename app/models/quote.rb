class Quote < ActiveRecord::Base

  has_many :traveler_members, dependent: :destroy

  accepts_nested_attributes_for :traveler_members, allow_destroy: true
  before_save :set_quote_id

  attr_reader :results

  def search
    get_ages()
    @results = self.send(:"#{self.traveler_type.downcase}_search")
    return self
  end

  def ages 
    @ages ||= {}
  end

  def get_rate_for(version)
    version.get_rates(ages["Adult"].max, self.sum_insured)
  end

  def get_ages
    year = Date.today.year
    @ages = {
      "Adult" => traveler_members.adult.map { |m| year - m.birthday.year },
      "Dependent" => traveler_members.dependent.map { |m| year - m.birthday.year }
    }
  end


  def single_search(age = nil)
    age = age || ages["Adult"].max

    @results = Version.send("#{self.traveler_type.downcase}")
    @results = @results.joins(:product).merge(Product.send((self.has_preex) ? "has_preex" : "has_no_preex"))
  
    if self.apply_from && beyond_30_days?
       @results = @results.where(:products => {can_buy_after_30_days: true})
    end
    
    if self.has_preex
      @results = @results.joins(:age_brackets).merge(AgeBracket.include_age(age).preex)
    else
      @results = @results.joins(:age_brackets).merge(AgeBracket.include_age(age))
    end

    @results = @results.joins(age_brackets: [:rates]).merge(Rate.include_sum(self.sum_insured))

    @results = @results.select("versions.*, rates.rate as product_rate").order("product_rate ASC")

    return @results
  end

  def couple_search
    single_search(ages["Adult"].max)
  end

  def family_search
  end

  #Class Methods
  def self.getFilters
    {
      "Cancellation" => %w{Trip\ Interruption Hurricane\ &\ Weather Terrorism Financial\ Default Employment\ Layoff Cancel\ For\ Work\ Reasons Cancel\ For\ Any\ Reason},
      "Medical" => %w{Primary\ Medical Emergency\ Medical Pre-existing\ Medical Medical\ Deductible},
      "Loss or Delay" => %w{Travel\ Delay Baggage\ Delay Baggage\ Loss Missed\ Connection},
      "Life Insurance" => %w{Accidental\ Death Air\ Flight\ Accident Common\ Carrier}
    }
  end

  def self.getSumInsured
    %w{ 10,000, 15,000 25,000 50,000 100,000 150,000 200,000, 250,000}
  end


  private

    def beyond_30_days?
      (Day.today - self.arrival_date) >= 30
    end

    #Before_Save
    def set_quote_id
      self.quote_id = "307-521-#{counter}"
    end

    def counter
      1
    end

end