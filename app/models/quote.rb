class Quote < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_many :traveler_members, dependent: :destroy
  has_many :applied_filte
  rs, dependent: :destroy
  has_many :product_filters, through: :applied_filters

  accepts_nested_attributes_for :traveler_members, allow_destroy: true

  validates :leave_home, :return_home, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :arrival_date, presence: true, if: "apply_from"
  validates :arrival_date, absence: true, unless: "apply_from"
  validates :trip_cost, numericality: { only_integer: true }, if: "trip_cost"
  validate :return_date_greater_leave_date
  validate :renew_check
  validate :renew_expire_check

  attr_reader :results, :pre_filtered_results, :filtered_results

  after_update :clear_cached

  def clear_cached
    self.touch
    Rails.cache.delete([self.class.name, id])
  end

  #Validation methods
  def return_date_greater_leave_date
    if leave_home.present? && return_home.present? && (leave_home >= return_home)
      errors.add(:base, "Return date cannot be lesser then departure date.")
    end
  end

  def renew_check
    if apply_from.present? && renew.nil?
      errors.add(:base, "Let us know if you're renewing a policy.")
    end 
  end

  def renew_expire_check
    if apply_from.present? && renew && renew_expire_date.nil?
      errors.add(:base, "Please provide a expired date for your current policy.")
    end
  end
  def complete
    if save
      set_quote_id
    else
      false
    end
  end

  def adult_members
    traveler_members.where(:member_type => "Adult")
  end

  def search
    calc_ages()
    @results = self.send(:"#{self.traveler_type.downcase}_search")
    @pre_filtered_results = @results
    cached_results(@results)
    return self
  end

  def sort_filters(filters)
    f = {}
    ProductFilter.sorted.each do |n|
      f[n] = filters[n.upcase]
    end
    return f
  end

  def cached_results(results)
    Rails.cache.fetch([self, results.object_id]) { results }
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
  
  #math for daily rate
  def calc_daily_rate(rate, type)
    case type
    when "Monthly"
      daily_rate = (rate / 30)
    when "Annually"
      daily_rate = (rate / 360)
    else
      daily_rate = rate
    end
    return daily_rate
  end
  
  #get the base rate for the version
  def calc_base_rate(version)
    rate = version.product_rate
    ratetype = version.rate_type

    if self.quote_type == "All Inclusive"
      return calc_all_inclusive_rate(rate, ratetype, version)
    end

    # Logic for couple and family rate
    if version.detail_type == "Couple" && !version.detail.has_couple_rate
      product_id = version.product_id
      t1 = @results["Traveler #1"].reject{ |t| t.product_id != product_id}
      t2 = @results["Traveler #2"].reject{ |t| t.product_id != product_id}
      if t1.any? and t2.any?
        rate = t1[0].product_rate + t2[0].product_rate
      end
    elsif self.traveler_type == "Family"
      rate = calc_family_rate(rate, version)
    end
    
    #reduce all rate to daily
    rate = calc_daily_rate(rate, ratetype)

    rate = (rate * self.traveled_days).round(2)

    # check to see if there is a min price and if there is
    # we use the greater of the two
    if version.product.min_rate_type == "Price"
      minprice = version.min_price
      if rate < minprice
        rate = minprice
      end
    elsif version.product.min_rate_type == "Date"
      mindate = version.product.min_date
      if mindate > self.traveled_days
        rate = (mindate * version.product_rate).round(2)
      end
    end

   return rate
  end

  def calc_all_inclusive_rate (rate, ratetype, version)
    if version.detail_type == "Couple" && !version.detail.has_couple_rate
      product_id = version.product_id
      t1 = @results["Traveler #1"].reject{ |t| t.product_id != product_id}
      t2 = @results["Traveler #2"].reject{ |t| t.product_id != product_id}
      if t1.any? and t2.any?
        rate = t1[0].product_rate + t2[0].product_rate
      end
    else
      r = calc_daily_rate(rate, ratetype)
      return r
    end
  end

  #if there is deductible we applie deductible multipler to the rates
  def calc_rate_with_ded(version, base_rate, person)
    rate = base_rate
    age = get_age_by_person(person)
    # check to see if any deductible filter has been applied
    if self.deductible_filter
      d = version.product.deductibles.age_between(age).merge(Deductible.deductible_eq(deductible_filter))
      rate = rate * d.first.mutiplier
    else
      d = version.product.deductibles.where(:amount => 0)
      if d.any?
        rate = rate * d.first.mutiplier
      end
    end
    return rate
  end

  def calc_family_rate(rate, version)
    r = nil;
    family_detail = version.family_details
    if family_detail.family_rate_type == "Has Family Rate"
      r = rate
    elsif family_detail.family_rate_type == "Eldest X2"
      r =  rate * 2
    else
      ages = [@ages["Adult"], @ages["Dependent"]].flatten
      rts = []

      ages.each do |age|
        rt  = version.age_brackets.merge(AgeBracket.include_age(age))[0].rates.merge(Rate.include_sum(self.sum_insured))
        if rate
          rts << rt[0]
        end
      end

      if rates.any?  
        r = rts.inject {|sum, n| sum + n } 
      else
        r = rate
      end
    end
    return r
  end

  def applied_filter_ids
    product_filters.pluck(:id)
  end

  def cached_applied_filter_ids
    @ids ||= product_filters.pluck(:id)
  end

  def not_include_filter?(filter)
    !applied_filter_ids.include?(filter)
  end

  # fetchs currently selected ded for each product
  def get_selected_ded(version, person)
    age = get_age_by_person(person)

    if self.deductible_filter
      d = version.product.deductibles.age_between(age).merge(Deductible.deductible_eq(deductible_filter))

      if d.any?
        return d.first.mutiplier
      else
        0
      end
    else
      return 0
    end
  end

  def get_deductible_by_age(product, person)
    age = get_age_by_person(person)
    product.get_deductible_by_age(age) 
  end

  #get age by person for couple rate
  def get_age_by_person(person)
    if self.traveler_type == "Couple"
      if person == "Traveler #2"
        @ages['Adult'][1]
      elsif person == "Couple"
        @ages['Adult'].max
      end
    else
      @ages['Adult'].max
    end
  end

  def filter_results
    self.search() unless cached_results(@pre_filtered_results)
    original_results = cached_results(@pre_filtered_results)

    if self.traveler_type == "Couple"
      @filtered_results = couple_filter(original_results)
      @results = couple_filter_results(original_results, @filtered_results)
    else
      @filtered_results = single_filter(original_results)
      @results = original_results - @filtered_results
    end
  end

  def single_filter(results, person = nil)
    dfiltered = []
    ffiltered = nil
    age = get_age_by_person((person || "Couple"))
    unless !deductible_filter
      dfiltered = results - filter_deductible(results, age)
    end

    ffiltered = results.to_a.reject do |r| 
      has_filters?(r.product_filters.pluck(:id), applied_filter_ids) 
    end
    
    final_filtered = (dfiltered + ffiltered).uniq

    return final_filtered
  end

  # since couple reults is a hash we must filter everyone
  def couple_filter(couple_results)
    h = Hash.new()
    couple_results.each do |k, v|
      h[k] = single_filter(v, k)
    end
    return h
  end

  # since couple reults is a hash we must filter everyone
  def couple_filter_results(original, filtered)
    h = Hash.new()
    original.each do |k, v|
      h[k] = v.to_a - filtered[k]
    end
    return h
  end

  def filter_deductible(original_results, age)
    original_results.joins(:product => [:deductibles]).merge(Deductible.deductible_eq(deductible_filter).age_between(age))
  end

  def traveled_days
    ((return_home - leave_home).to_i  / 1.day)
  end

  def single_search(age = nil, rate_type = nil)
    age = age || ages["Adult"].max
    rate_type = rate_type || self.traveler_type.downcase
    result = Version.send(rate_type).joins(:product).merge(Product.policy_type_of(self.quote_type).active)


    if self.apply_from && beyond_30_days? && !self.renew
      result = result.merge(Product.can_buy_after_30)
    elsif self.apply_from && beyond_30_days? && self.renew
      result = result.merge(Product.renewable_after_30)
    end

    if self.has_preex
      result = result.merge(Product.has_preex)
      result = result.joins(:age_brackets).merge(AgeBracket.include_age(age).preex)
    else
      result = result.joins(:age_brackets).merge(AgeBracket.include_age(age))
    end

    if self.quote_type == "All Inclusive"
      result = result.joins(age_brackets: [:all_inclusive_rates]).merge(
        AllInclusiveRate.include_date(self.traveled_days).include_sum(self.sum_insured)
        .has_trip_value_of(self.trip_cost))
      result = result.select("versions.*, all_inclusive_rates.rate as product_rate, 
        all_inclusive_rates.rate_type as rate_type, products.min_price as min_price, 
        products.min_date as min_date, products.id as product_id").order("product_rate ASC")
    else  
      result = result.joins(age_brackets: [:rates]).merge(Rate.include_sum(self.sum_insured))
      result = result.select("versions.*, rates.rate as product_rate, 
        rates.rate_type as rate_type, products.min_price as min_price, 
        products.min_date as min_date, products.id as product_id").order("product_rate ASC")
    end

    return result
  end

  def couple_search
    result = Hash.new()
    result["Couple"] =  single_search(ages["Adult"].max)
    result["Traveler #1"] =  single_search(ages["Adult"].first, "single")
    result["Traveler #2"] =  single_search(ages["Adult"].last, "single")
    return result
  end

  def family_search
    age = [@ages["Adult"], @ages["Dependent"]].flatten.max
    single_search(age, "family")
  end

  #Class Methods
  class << self
    def all_inclusive_selections
      self.super_visa_selections << "Family"
    end

    def all_inclusive_sum
      %w{25,000 50,000 100,000 150,000 200,000}
    end

    def visitor_visa_selections
      self.super_visa_selections << "Family"
    end

    def super_visa_selections
      ["Single", "Couple"]
    end

    def cached_find(id)
      Rails.cache.fetch([name, id]) {find(id)}
    end

    def visitor_visa_sum
      %w{25,000 50,000 100,000 150,000 200,000}
    end

    def super_visa_sum
      self.visitor_visa_sum.drop(2)
    end

    def ded_filters
      ["0", "1 - 100", "101 - 250", "251 - 500", "501 - 1000",
       "1001 - 3000", "3001 - 5000", "5001 - 10000"]
    end

  end

  private
    def has_filters?(pfilters, afilters)
      if  afilters.blank?
        return true
      elsif pfilters.blank? 
        return false
      else
        (afilters - (pfilters & afilters)).blank?
      end
    end

    def beyond_30_days?
      (Date.today - self.arrival_date.to_datetime).to_i >= 30
    end

    #Before_Save
    def set_quote_id
      strid = self.id.to_s
      if strid.length > 3
        quote_id = "307-#{strid.slice(0..2)}-#{strid.slice(3..5)}"
      else
        quote_id = "307-#{strid}"
      end
      update(quote_id: quote_id)
    end

end