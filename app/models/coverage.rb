class Coverage < ActiveRecord::Base
  belongs_to :policy
  belongs_to :coverage_categories
end
