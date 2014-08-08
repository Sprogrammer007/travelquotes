class StudentFilterSet < ActiveRecord::Base
  DEFAULT_HEADER = %w{student_filter_id student_product_id}

  belongs_to :student_product
  belongs_to :student_filter
  self.primary_key = :student_product_id 
end
