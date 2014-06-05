ActiveAdmin.register ProductFilter do
	config.sort_order = "id_asc"
	config.paginate = false
	include_import

	permit_params :category, :name, :policy_type, :descriptions

 	#Scopes
 	scope :all, default: true
  scope :medical_benefits
  scope :right_of_entry

	#Filters
	preserve_default_filters!
	remove_filter :product_filter_sets
	remove_filter :applied_filters
	remove_filter :quotes
	remove_filter :created_at
	remove_filter :updated_at

	menu :parent => "Global Settings"

	index do
		selectable_column
		column :name
		column :category
		column :descriptions do |p|
			p.descriptions.html_safe() if p.descriptions
		end
		actions defaults: true, dropdown: true
	end
	form do |f|
		f.inputs do
			f.input :name
			f.input :category, :as => :select, :collection => options_for_select(ProductFilter.filter_categories, f.object.category)
			f.input :policy_type, :as => :select, :collection => options_for_select(["Visitor Visa", " Super Visa", "Both"], f.object.policy_type)
			f.input :descriptions, input_html: { class: "tinymce" }

		end
		f.actions
	end
end
