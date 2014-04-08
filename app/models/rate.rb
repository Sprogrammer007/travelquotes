class Rate < ActiveRecord::Base
	DEFAULT_HEADER = %w{age_bracket_id eff_dat rate}
	
  belongs_to :age_bracket
end
