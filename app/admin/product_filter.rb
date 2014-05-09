ActiveAdmin.register ProductFilter do
	config.sort_order = "id_asc"
	config.paginate = false
	include_import

 	#Scopes
 	scope :all, default: true
  scope :medical_benefits
  scope :right_of_entery

	#Filters
	preserve_default_filters!
	remove_filter :product_filter_sets
	remove_filter :created_at
	remove_filter :updated_at

	menu :parent => "Products"

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
