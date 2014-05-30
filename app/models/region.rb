class Region < ActiveRecord::Base
	DEFAULT_HEADER = %w{province_id company_id}
 
	belongs_to :company
	belongs_to :province
	self.primary_key = :province_id 
end