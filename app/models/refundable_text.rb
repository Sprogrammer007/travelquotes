class RefundableText < ActiveRecord::Base
	DEFAULT_HEADER = %w{policy_id describition policy_type}
  
  belongs_to :policy
end
