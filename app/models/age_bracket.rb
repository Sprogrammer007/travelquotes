class AgeBracket < ActiveRecord::Base
	DEFAULT_HEADER = %w{range policy_id min_age max_age}
	
  belongs_to :policy, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :sum_insured, dependent: :destroy

end
