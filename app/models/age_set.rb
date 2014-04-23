class AgeSet < ActiveRecord::Base
	 DEFAULT_HEADER = %w{age_bracket_id plan_id}
	belongs_to :plan
	belongs_to :age_bracket, :dependent => :destroy
	self.primary_key = :plan_id 
end