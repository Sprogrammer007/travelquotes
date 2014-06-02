ActiveAdmin.register ProductFilter do
	config.sort_order = "id_asc"
	config.paginate = false
	include_import

<<<<<<< HEAD
 	#Scopes
 	scope :all, default: true
  scope :medical_benefits
  scope :right_of_entery
=======
	permit_params :category, :name, :policy_type, :descriptions

 	#Scopes
 	scope :all, default: true
  scope :medical_benefits
  scope :right_of_entry
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232

	#Filters
	preserve_default_filters!
	remove_filter :product_filter_sets
<<<<<<< HEAD
=======
	remove_filter :applied_filters
	remove_filter :quotes
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
	remove_filter :created_at
	remove_filter :updated_at

	menu :parent => "Products"

	index do
		selectable_column
		column :name
		column :category
		column :descriptions do |p|
<<<<<<< HEAD
			p.descriptions.html_safe if p.descriptions
		end
		default_actions
	end

	
=======
			p.descriptions.html_safe() if p.descriptions
		end
		actions defaults: true, dropdown: true
	end

>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
end
