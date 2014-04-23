class Product < ActiveRecord::Base

  # DEFAULT_HEADER = %w{name product_number eff_date
  #   describition purchase_url can_buy_after_30_days status company_id min_age
  #   max_age max_age_with_kids min_trip_duration max_trip_duration
  #   min_adult max_adult min_dependant max_dependant min_price
  #   super_visa_partial_refund right_of_entry renewable renewable_period renewable_max_age
  #   follow_ups }
  DEFAULT_HEADER = %w{name product_number rate_type description can_buy_after_30_days
  	status company_id}
  
  belongs_to :company
  has_many :deductibles
  has_many :plans
  has_many :product_filters
  has_many :rates

end
