class ProductFilter < ActiveRecord::Base
	DEFAULT_HEADER = %w{category name policy_type descriptions}

  has_many :product_filter_sets
  has_many :product, :through => :product_filter_sets
  belongs_to :legal_text_category, foreign_key: "associated_lt_id"
  has_many :applied_filters
  has_many :quotes, :through => :applied_filters
  

  private
    def self.filter_categories
      %w{Medical\ Benefits Repatriation\ to\ Residence Medical\ Emergency\ Transportation
      Trip\ Cancellation\ &\ Interuption Terrorism Life\ &\ Accident\ Insurance Side\ Trips
      Right\ of\ Entry Extensions\ &\ Renewals Refunds Non\ Medical\ Benefits Sports\ &\ Activities}
    end
end
