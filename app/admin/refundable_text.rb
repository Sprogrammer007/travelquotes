ActiveAdmin.register RefundableText do
	config.sort_order = "id_asc"
	include_import
	preserve_default_filters!
  filter :policy, :collection => proc {(Policy.all).map{|c| [c.policy_name, c.id]}}
  menu :parent => "Policies"
  
end
