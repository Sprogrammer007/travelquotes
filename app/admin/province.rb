ActiveAdmin.register Province do
	config.sort_order = "id_asc"
	include_import
  menu :parent => "Companies"
  permit_params :name, :short_hand, :company_ids
  
  #Filters
	preserve_default_filters!
	remove_filter :regions

	#Index
	index do 
		selectable_column
		column :flag do |p|
			image_tag p.flag, size: "50x50"
		end
		column :name
		column :short_hand
		column :country
		actions defaults: true, dropdown: true
	end

	#Show

	show do |p|
		attributes_table do
			row :name
			row :short_hand 
			row :flag do |p|
				image_tag p.flag, size: "80x80"
			end
			row :country
			
		end
	end

	#Form
	form do |f|
		f.inputs do
			f.input :flag
			f.input :name
			f.input :short_hand
			f.input :country, as: :select, :collection => options_for_select(["Canada"])
		end
		f.actions
	end

	#Custom Actions
	action_item :only => :show do
   link_to("Add #{province.class.name}", action: 'new')
  end
end
