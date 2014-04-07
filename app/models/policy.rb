class Policy < ActiveRecord::Base
  belongs_to :company

  has_many :age_bracket
end
