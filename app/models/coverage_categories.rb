class CoverageCategories < ActiveRecord::Base
	DEFAULT_HEADER = %w{name policy_id description order}

  belongs_to :policy
end
