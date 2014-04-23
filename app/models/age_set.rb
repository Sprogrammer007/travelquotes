class AgeSet < ActiveRecord::Base
	belongs_to :plan
	belongs_to :age_bracket, :dependent => :destroy
	self.primary_key = :plan_id 
end