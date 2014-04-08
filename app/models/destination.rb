class Destination < ActiveRecord::Base
	DEFAULT_HEADER = %w{policy_id place}
  belongs_to :policy
end
