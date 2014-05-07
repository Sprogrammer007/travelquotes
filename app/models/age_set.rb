class AgeSet < ActiveRecord::Base
	DEFAULT_HEADER = %w{age_bracket_id version_id}
	belongs_to :version
	belongs_to :age_bracket, :dependent => :destroy
	self.primary_key = :version_id 
end