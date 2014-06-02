class LegalText < ActiveRecord::Base
<<<<<<< HEAD

  belongs_to :product
=======
  DEFAULT_HEADER = %w{product_id legal_text_category_id policy_type description effective_date status}

  belongs_to :product
  belongs_to :legal_text_category
  attr_accessor :parent_category

>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
end
