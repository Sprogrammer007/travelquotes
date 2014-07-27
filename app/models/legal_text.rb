class LegalText < ActiveRecord::Base
  DEFAULT_HEADER = %w{product_id legal_text_category_id policy_type description status}

  belongs_to :product
  belongs_to :legal_text_category
  attr_accessor :parent_category

  def self.ordered
    joins(:legal_text_category => [:legal_text_parent_category]).order("legal_text_parent_categories.order asc").order("legal_text_categories.order asc")
  end
  
  def self.has_legal_text_of_version?(lgs, type)
    if lgs
      a = lgs.select { |lg| lg.policy_type == type}
      if a.any?
        return true
      else
        return false
      end
    end
    return false
  end
end
