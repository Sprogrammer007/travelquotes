class StudentFamilyDetail < ActiveRecord::Base
  DEFAULT_HEADER = %w{ min_age max_age min_dependant max_dependant
  min_adult max_adult max_kids_age max_age_with_kids family_rate_type}
  has_one :student_version, as: :detail

  def has_special_rate?
    family_rate_type == "Has Family Rate"
  end
end
