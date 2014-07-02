class LegalText < ActiveRecord::Base
  DEFAULT_HEADER = %w{product_id legal_text_category_id policy_type description effective_date status}

  belongs_to :product
  belongs_to :legal_text_category
  attr_accessor :parent_category

  def self.ordered
    joins(:legal_text_category => [:legal_text_parent_category]).order("legal_text_parent_categories.order asc").order("legal_text_categories.order asc")
  end

end
