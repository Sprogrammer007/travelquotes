class Deductible < ActiveRecord::Base
	DEFAULT_HEADER = %w{policy_id mutiplier age condition amount}

  belongs_to :policy
end
