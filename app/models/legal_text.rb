class LegalText < ActiveRecord::Base
  DEFAULT_HEADER = %w{product_id legal_text_category_id policy_type description effective_date status}

  belongs_to :product
  belongs_to :legal_text_category
  attr_accessor :parent_category

end
