class FamilyDetail < ActiveRecord::Base
  DEFAULT_HEADER = %w{ min_age max_age min_dependant max_dependant
  min_adult max_adult max_kids_age max_age_with_kids has_family_rate}
  has_one :version, as: :detail, dependent: :destroy

  def has_special_rate?
    has_family_rate
  end
end
