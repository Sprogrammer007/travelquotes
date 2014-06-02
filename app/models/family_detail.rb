class FamilyDetail < ActiveRecord::Base
  DEFAULT_HEADER = %w{ min_age max_age min_dependant max_dependant
  min_adult max_adult max_kids_age max_age_with_kids has_family_rate}
<<<<<<< HEAD
  has_one :version, as: :detail, dependent: :destroy
=======
  has_one :version, as: :detail
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232

  def has_special_rate?
    has_family_rate
  end
end
