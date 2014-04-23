ActiveAdmin.register PlanFilter do
	config.sort_order = "id_asc"
	include_import

 	#Scopes
 	scope :all, default: true
 	# scope :non_medical_benefits

	#Filters
	preserve_default_filters!
	remove_filter :plan_filter_sets
	remove_filter :created_at
	remove_filter :updated_at
	filter :product
	filter :plans, :collection => -> {PlanFilter.plans_filter_selection}

	menu :parent => "Plans"

	index do
		selectable_column
		column :name
		column :category
		column :description do |p|
			p.description.html_safe
		end
		default_actions
	end

	
end
