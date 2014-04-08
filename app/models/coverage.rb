class Coverage < ActiveRecord::Base
	DEFAULT_HEADER = %w{name policy_id category_id description order}

  belongs_to :policy
  belongs_to :coverage_categories, :foreign_key => :category_id

  def default_coverages
  	%w{	Pre-Existing 
  			Medical\ Conditions 
  			Heart\ Condition
				Lung\ Condition
				Follow\ up\ Visits
				Annual\ Medical\ Check\ up
				Annual\ Eye\ Exam
				Vaccines\ Medical\ Emergency
				Vaccines\ Annual\ Check up
				Child\ Care
				Maternity\ (Pregnancy)
				Out\ of\ Pocket\ Expenses
				Medical\ Emergency\ Extensions 
				Return\ of\ Deceased
				Cremation\ Burial\ at\ Destination
				Emergency\ Return\ Home 
				Travel\ Companion\ Emergency\ Return\ Home
				Childen\ Emergency\ Return\ Home 
				Baggge\ Retuns
				Transportation\ of\ Family\ or\ Friend
				Trip\ Cancelation\ &\ Interuption 
				Trip\ Interuption
				Terrorism
				AD\ &D
				Flight\ Accident
				Exposure\ and\ Disappearance
				Worldwide
				USA\ &\ Mexico
				Cuba
				Right\ of\ Entry 
				Up\ to\ 6\ Month
				Up\ to\ 12\ Month
				Up\ to\ 24\ Month
				Prior\ to\ Effective\ Date\ (Departure)
				Partial\ Refunds\ After\ Effective\ Date\ (Arrival) 
				Refunds\ if\ Visitors\ Visa\ Denied/Rejected
				Refunds\ if\ Super\ Visa\ Denied/Rejected
				Partial\ Refunds\ After\ Effective\ Date\ (Arrival) 
				Prior\ to\ Effective\ Date\ (Departure) 
				Baggage\ Loss\ &\ Delay
				24\ Hour\ Travel\ Assistance
				Money\ Back\ Guarantee
			}
  end
end
