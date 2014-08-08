class StudentSingleDetail < ActiveRecord::Base
  DEFAULT_HEADER = %w{ min_age max_age }
  
  has_one :student_version, as: :detail
  
  def has_special_rate?
    false
  end
end
