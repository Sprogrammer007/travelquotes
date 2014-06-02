class AgeSet < ActiveRecord::Base
	DEFAULT_HEADER = %w{age_bracket_id version_id}
	belongs_to :version
<<<<<<< HEAD
	belongs_to :age_bracket, :dependent => :destroy
=======
	belongs_to :age_bracket
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
	self.primary_key = :version_id 
end