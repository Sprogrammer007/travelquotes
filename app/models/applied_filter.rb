class AppliedFilter < ActiveRecord::Base
<<<<<<< HEAD
  belongs_to :quote
=======
  belongs_to :quote, touch: true
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
  belongs_to :product_filter
  self.primary_key = :quote_id 
end
