class StudentCoupleDetail < ActiveRecord::Base
  DEFAULT_HEADER = %w{ min_age max_age has_couple_rate }
  
  has_one :student_version, as: :detail

  def has_special_rate?
    has_couple_rate
  end
end
