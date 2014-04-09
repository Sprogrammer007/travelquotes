ActiveAdmin.register Company do
	config.sort_order = "id_asc"
	include_import
	preserve_default_filters!
  filter :policy, :collection => proc {(Policy.all).map{|c| [c.policy_name, c.id]}}

	index do
		column :name
		column :short_hand
		column :logo
		column "Active", :status
		actions :defaults => true
	end
  
end
