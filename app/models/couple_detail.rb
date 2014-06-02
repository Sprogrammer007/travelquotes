class CoupleDetail < ActiveRecord::Base
  DEFAULT_HEADER = %w{ min_age max_age has_couple_rate }
  
<<<<<<< HEAD
  has_one :version, as: :detail, dependent: :destroy
=======
  has_one :version, as: :detail
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232

  def has_special_rate?
    has_couple_rate
  end
end
