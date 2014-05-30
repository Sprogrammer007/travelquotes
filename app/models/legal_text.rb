class LegalText < ActiveRecord::Base
  DEFAULT_HEADER = %w{product_id name policy_category policy_sub_category description effective_date status}

  belongs_to :product

  def self.sub_category_options
    [
      ["Visitor Visa", ["Super Visa", "Visitor Visa", "Both"]],
      ["Student Visa", ["None"]]
    ]
  end
end
