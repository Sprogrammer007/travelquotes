class SumInsured < ActiveRecord::Base
	DEFAULT_HEADER = %w{age_bracket_id max_age amount}
  belongs_to :age_bracket, dependent: :destroy
end
