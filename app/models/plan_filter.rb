class PlanFilter < ActiveRecord::Base
	DEFAULT_HEADER = %w{category name policy_type descriptions}

  has_many :plan_filter_sets
  has_many :plans, :through => :plan_filter_sets
 	
  scope :preex, -> { where(:category => "Pre-Existing Medical Conditions") } 
  scope :medical_benefits, -> { where(:category => "MEDICAL BENEFITS") }
 	scope :repatriation_to_residence, -> { where(:category => "REPATRIATION TO RESIDENCE") }
  scope :medical_emergency, -> { where(:category => "MEDICAL EMERGENCY TRANSPORTATION") }
  scope :trip_cancellation, -> { where(:category => "TRIP CANCELLATION & INTERUPTION") }
  scope :terrorism, -> { where(:category => "Terrorism") }
  scope :life_accident, -> { where(:category => "LIFE & ACCIDENT INSURANCE") }
  scope :side_trips, -> { where(:category => "SIDE TRIPS") }
  scope :right_of_entery, -> { where(:category => "RIGHT OF ENTERY") }
  scope :refunds, -> { where(:category => "REFUNDS") }

  def self.plans_filter_selection
		Hash[Product.all.map {|pro| [ pro.name, pro.plans.map {|p| [pro.name + " (#{p.type})", p.id]} ]}]
	end
end
