class StudentAppliedFilter < ActiveRecord::Base
  belongs_to :student_quote, touch: true
  belongs_to :student_filter
  self.primary_key = :student_quote_id 

end
