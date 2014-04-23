class PlanFilterSet < ActiveRecord::Base
	belongs_to :plan
	belongs_to :plan_filter, :foreign_key => :filter_id
	self.primary_key = :plan_id 
end