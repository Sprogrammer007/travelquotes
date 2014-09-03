class StudentQuote < ActiveRecord::Base

  has_many :student_traveler_members, dependent: :destroy
  has_many :student_applied_filters, dependent: :destroy
  has_many :student_filters, through: :student_applied_filters
  
  validates :leave_home, :return_home, presence: true
  validates :email, presence: true, format: { with: Quote::VALID_EMAIL_REGEX }
  validate :return_date_greater_leave_date


  accepts_nested_attributes_for :student_traveler_members, allow_destroy: true

  attr_reader :results, :pre_filtered_results, :filtered_results

  after_update :clear_cached

  #Validation methods
  def return_date_greater_leave_date
    if leave_home.present? && return_home.present? && (leave_home >= return_home)
      errors.add(:base, "Return date cannot be lesser then departure date.")
    end
  end

  def clear_cached
    self.touch
    Rails.cache.delete([self.class.name, id])
  end

  def adult_members
    student_traveler_members.where(:member_type => "Adult")
  end

  def search
    calc_ages()
    @results = self.send(:"#{self.traveler_type.downcase}_search")
    @pre_filtered_results = @results
    cached_results(@results)
    return self
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
      "Adult" => student_traveler_members.adult.map { |m| year - m.birthday.year },
      "Dependent" => student_traveler_members.dependent.map { |m| year - m.birthday.year }
    }
  end

  #get the base rate for the version
  def calc_base_rate(version)
    ab = version.age_bracket
    rate = calc_rate_by_type(ab, "student")

    # Logic for couple and family rate
    if version.detail_type == "Couple" && !version.detail.has_couple_rate

      rate_family = calc_rate_by_type(ab, "family")

      if t1.any? and t2.any?
        rate = rate + rate_family
      end
    elsif self.traveler_type == "Family"
      rate = calc_family_rate(rate, version)
    end

    rate = (rate * self.traveled_days).round(2)

    # check to see if there is a min price and if there is
    # we use the greater of the two
    if version.student_product.min_rate_type == "Price"
      minprice = version.min_price
      if rate < minprice
        rate = minprice
      end
    elsif version.student_product.min_rate_type == "Date"
      mindate = version.product.min_date
      if mindate > self.traveled_days
        rate = (mindate * version.product_rate).round(2)
      end
    end

   return rate
  end

  def calc_rate_by_type(age_bracket, type)
    rate = 0
    if plan_type == "Annually"
      rate = age_bracket.student_rates.where(StudentRate.annual.send(type))
      if rate.any?
        rate = rate.first
      else
        rate = age_bracket.student_rates.where(StudentRate.daily.send(type)).first
        rate = rate * 365
      end
    else
      rate = age_bracket.student_rates.where(StudentRate.daily.send(type)).first
    end
    return rate
  end

  def complete
    if save
      set_quote_id
    else
      false
    end
  end

  def sort_filters(filters)
    f = {}
    StudentFilter.sorted.each do |n|
      f[n] = filters[n.upcase]
    end
    return f
  end

  def cached_applied_filter_ids
    @ids ||= student_filters.pluck(:id)
  end

  def traveled_days
    ((return_home - leave_home).to_i  / 1.day)
  end

  def single_search(age = nil, rate_type = nil)
    age = age || ages["Adult"].max
    rate_type = rate_type || self.traveler_type.downcase
    result = StudentVersion.send(rate_type).joins(:student_product).merge(StudentProduct.active)

    if self.has_preex
      result = result.merge(StudentProduct.has_preex)
      result = result.joins(:student_age_brackets).merge(StudentAgeBracket.include_age(age).preex)
    else
      result = result.joins(:student_age_brackets).merge(StudentAgeBracket.include_age(age))
    end

    result = result.select("student_versions.*, student_age_brackets.* as age_bracket, student_products.min_price as min_price, 
      student_products.min_date as min_date, student_products.id as product_id")
  
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
    def traveler_type_selection
      ["Single", "Couple", "Family"]
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
