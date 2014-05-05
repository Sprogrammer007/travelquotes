class FamilyDetail < ActiveRecord::Base
  has_one :plan, as: :detail, dependent: :destroy
end
