ActiveAdmin.register PlanFilter do
	config.sort_order = "id_asc"
	config.paginate = false
	include_import

 	#Scopes
 	scope :all, default: true
  scope :preex
  scope :medical_benefits
  scope :medical_emergency
  scope :trip_cancellation
  scope :life_accident
  scope :side_trips

	#Filters
	preserve_default_filters!
	remove_filter :plan_filter_sets
	remove_filter :created_at
	remove_filter :updated_at

	filter :plans, :collection => -> {PlanFilter.plans_filter_selection}

	menu :parent => "Plans"

	index do
		selectable_column
		column :name
		column :category
		column :descriptions do |p|
			p.descriptions.html_safe if p.descriptions
		end
		default_actions
	end

	
end
