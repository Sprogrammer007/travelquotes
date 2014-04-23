ActiveAdmin.register AgeBracket do
	menu :parent => "Plans"
	config.sort_order = "id_asc"
	include_import

	#Filters
	preserve_default_filters!
	filter :product
	filter :plans, :collection => -> {AgeBracket.plans_filter_selection}

	remove_filter :age_sets
	remove_filter :rates


	index do
		selectable_column
		column :range
		column :min_age
		column :max_age
		default_actions
	end

	form do |f|
		f.inputs do
			f.input :range
			f.input :min_age
			f.input :max_age
			f.input :product,	:input_html => { :class => 'tier1_select' }
			f.input :plans,		:as => :select,	:input_html => { :class => 'tier2_select' },
							:collection => grouped_options_for_select(AgeBracket.product_selection, 
														age_bracket.plans.map { |p| p.id })
		end
		f.actions
	end

end
