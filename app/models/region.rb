class Region < ActiveRecord::Base
	belongs_to :company
	belongs_to :province
	self.primary_key = :province_id 
end