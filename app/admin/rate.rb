ActiveAdmin.register Rate do
	config.sort_order = "id_asc"
	include_import

	#Scopes
	scope :all, default: true
	scope :has_pre_existing_medicals

	#Filters
	filter :age_bracket, :collection => proc { Rate.select_age_bracket_options }  
	filter :preex, :as => :select, :collection => [['Yes', 'true'], ['No', 'false']]
	remove_filter :preex
	preserve_default_filters!

	menu :parent => "Plans"
	
	#Index Table
	index do
		selectable_column
		column :sum_insured
		column :preex
		column :rate
		column :effective_date
		default_actions
	end

	#Form
	form do |f|
		f.inputs do
			f.input :age_bracket
			f.input :sum_insured
			f.input :preex
			f.input :effective_date, :as => :datepicker, :input_html => { :readonly => true } 
			f.input :rate
		end
		f.actions
	end

end
