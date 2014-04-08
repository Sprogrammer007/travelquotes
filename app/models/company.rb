class Company < ActiveRecord::Base
	DEFAULT_HEADER = %w{name short_hand logo status}
	
	has_many :policy, dependent: :destroy
	has_many :provinces, dependent: :destroy

	#query scopes

	def self.recent(lmt)
		order('created_at desc').limit(lmt)
	end
end
