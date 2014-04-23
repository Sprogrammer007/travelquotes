class ProductFilter < ActiveRecord::Base
	DEFAULT_HEADER = %w{name category product_id description}
	belongs_to :product

	scope :non_medical_benefits, -> { where(:category => "NON-MEDICAL BENEFITS") }
	scope :medical_benefits, -> { where(:category => "MEDICAL BENEFITS") }





end
