class Quote < ActiveRecord::Base

  has_many :traveler_members, dependent: :destroy
  has_many :applied_filters, dependent: :destroy
  has_many :product_filters, through: :applied_filters

  accepts_nested_attributes_for :traveler_members, allow_destroy: true
  before_save :set_quote_id

  attr_reader :results, :pre_filtered_results, :filtered_results

  def search
    calc_ages()
    @results = self.send(:"#{self.traveler_type.downcase}_search")
    @pre_filtered_results = @results
    return self
  end

  def ages 
    @ages ||= {}
  end

  def calc_ages
    year = Date.today.year
    @ages = {
      "Adult" => traveler_members.adult.map { |m| year - m.birthday.year },
      "Dependent" => traveler_members.dependent.map { |m| year - m.birthday.year }
    }
  end

  def calc_rate(version)
    rate = version.product_rate
    if version.detail_type == "Couple" && !version.detail.has_couple_rate
      product_id = version.product_id
      t1 = @results["Traveler #1"].reject{ |t| t.product_id != product_id}
      t2 = @results["Traveler #2"].reject{ |t| t.product_id != product_id}
      if t1.any? and t2.any?

        rate = t1[0].product_rate + t2[0].product_rate
      end
    end
   (rate * (self.traveled_days / 1.day)).round(2)
  end

  def filter_results
    if @results.is_a?(ActiveRecord::Relation)
      @filtered_results = @results.reject do |r| 
        has_filters?(r.product.product_filters.pluck(:id), self.product_filters.pluck(:id)) 
      end
    end

    @results = @results.to_a - @filtered_results
  end

  def traveled_days
    (self.return_home - self.leave_home).to_i
  end


  def single_search(age = nil, rate_type = nil)
    age = age || ages["Adult"].max
    rate_type = rate_type || self.traveler_type.downcase
    result = Version.send(rate_type)
   
    if self.apply_from && beyond_30_days?
       result = result.where(:products => {can_buy_after_30_days: true})
    end
    
    if self.has_preex
      result = result.joins(:product).merge(Product.has_preex)
      result = result.joins(:age_brackets).merge(AgeBracket.include_age(age).preex)
    else
      result = result.joins(:age_brackets).merge(AgeBracket.include_age(age))
    end

    result = result.joins(age_brackets: [:rates]).merge(Rate.include_sum(self.sum_insured))
    result = result.select("versions.*, rates.rate as product_rate, rates.rate_type as rate_type").order("product_rate ASC")

    if self.traveler_type == "Single"
      @results = result
      return @results
    end

    return result
  end

  def couple_search
    @results = Hash.new()
    @results["Couple"] =  single_search(ages["Adult"].max)
    @results["Traveler #1"] =  single_search(ages["Adult"].first, "single")
    @results["Traveler #2"] =  single_search(ages["Adult"].last, "single")
    return @results
  end

  def family_search
  end

  #Class Methods
  def self.getFilters
    ProductFilter.prepare_filters
  end

  def self.getSumInsured
    %w{ 10,000, 15,000 25,000 50,000 100,000 150,000 200,000, 250,000}
  end


  private
    def has_filters?(pfilters, afilters)
      (afilters - (pfilters & afilters)).any?
    end

    def beyond_30_days?
      (Day.today - self.arrival_date) >= 30
    end

    #Before_Save
    def set_quote_id
      self.quote_id = "307-521-#{self.id}"
    end

end