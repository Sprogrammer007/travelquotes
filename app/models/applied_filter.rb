class AppliedFilter < ActiveRecord::Base
  belongs_to :quote, touch: true
  belongs_to :product_filter
  self.primary_key = :quote_id 
end
