class Policy < ActiveRecord::Base

  DEFAULT_HEADER = %w{policy_name short_hand policy_number eff_date rate_type
    describition purchase_url can_buy_after_30_days status company_id min_age
    max_age max_age_with_kids min_trip_duration max_trip_duration
    min_adult max_adult min_dependant max_dependant min_price preex preex_max_age
    super_visa_partial_refund right_of_entry renewable renewable_period renewable_max_age
    follow_ups }
  
  belongs_to :company
  has_many :age_bracket
  
end
