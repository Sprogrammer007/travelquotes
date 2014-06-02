class ProductFilter < ActiveRecord::Base
	DEFAULT_HEADER = %w{category name policy_type descriptions}

  has_many :product_filter_sets
  has_many :product, :through => :product_filter_sets
<<<<<<< HEAD
 	
=======
 
  has_many :applied_filters
  has_many :quotes, :through => :applied_filters
  
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
  #scopes
  generate_scopes

  scope :medical_benefits, -> {  category_eq("MEDICAL BENEFITS") }
 	scope :repatriation_to_residence, -> { category_eq("REPATRIATION TO RESIDENCE") }
  scope :medical_emergency_transportation, -> { category_eq("MEDICAL EMERGENCY TRANSPORTATION") }
  scope :trip_cancellation_and_interuption, -> { category_eq("TRIP CANCELLATION & INTERUPTION") }
  scope :terrorism, -> { category_eq("Terrorism") }
  scope :life_and_accident_insurance, -> { category_eq("LIFE & ACCIDENT INSURANCE") }
  scope :side_trips, -> { category_eq("SIDE TRIPS") }
<<<<<<< HEAD
  scope :right_of_entery, -> { category_eq("RIGHT OF ENTERY") }
  scope :extensions_and_renewals, -> { category_eq("EXTENSIONS AND RENEWALS") }
=======
  scope :right_of_entry, -> { category_eq("RIGHT OF ENTERY") }
  scope :extensions_and_renewals, -> { category_eq("EXTENSIONS & RENEWALS") }
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
  scope :refunds, -> { category_eq("REFUNDS") }
  scope :non_medical_benefits, -> { category_eq("NON MEDICAL BENEFITS") }

  def self.prepare_filters
    filters = {}
    ProductFilter.filter_categories.each do |f|
      filters[f] = ProductFilter.send(f.gsub("&", "AND").gsub(" ", "_").downcase)
    end
    return filters
  end

  private
    def self.filter_categories
      %w{Medical\ Benefits Repatriation\ to\ Residence Medical\ Emergency\ Transportation
      Trip\ Cancellation\ &\ Interuption Terrorism Life\ &\ Accident\ Insurance Side\ Trips
<<<<<<< HEAD
      Right\ of\ Entery Extensions\ AND\ Renewals Refunds Non\ Medical\ Benefits}
=======
      Right\ of\ Entry Extensions\ &\ Renewals Refunds Non\ Medical\ Benefits}
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
    end
end
