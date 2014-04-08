class AgeBracket < ActiveRecord::Base
	DEFAULT_HEADER = %w{range policy_id min_age max_age}
	
  belongs_to :policy


end
