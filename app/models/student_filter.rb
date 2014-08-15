class StudentFilter < ActiveRecord::Base
  DEFAULT_HEADER = %w{category name descriptions}

  has_many :student_filter_sets
  has_many :student_product, :through => :student_filter_sets
  belongs_to :student_lg_cat, foreign_key: "associated_lt_id"
  has_many :student_applied_filters
  has_many :student_quotes, :through => :student_applied_filters
  

  private
    def self.filter_categories
      %w{Medical\ Benefits Repatriation\ to\ Residence Medical\ Emergency\ Transportation
      Trip\ Cancellation\ &\ Interuption Terrorism Life\ &\ Accident\ Insurance Side\ Trips
      Right\ of\ Entry Extensions\ &\ Renewals Refunds Non\ Medical\ Benefits}
    end
end
