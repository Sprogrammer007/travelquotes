class PlanFilterSet < ActiveRecord::Base
	DEFAULT_HEADER = %w{filter_id plan_id}
 

	belongs_to :plan
	belongs_to :plan_filter, :foreign_key => :filter_id
	self.primary_key = :plan_id 
end