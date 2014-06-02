class ProductFilterSet < ActiveRecord::Base
	DEFAULT_HEADER = %w{product_filter_id product_id}
 
	belongs_to :product
	belongs_to :product_filter
	self.primary_key = :product_id 
end