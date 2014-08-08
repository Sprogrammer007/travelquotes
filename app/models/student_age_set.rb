class StudentAgeSet < ActiveRecord::Base
  DEFAULT_HEADER = %w{student_age_bracket_id student_version_id}
  belongs_to :student_version
  belongs_to :student_age_bracket
  self.primary_key = :student_version_id 
end

