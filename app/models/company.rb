class Company < ActiveRecord::Base
	DEFAULT_HEADER = %w{name short_hand logo status}
	
	has_many :policy

end
