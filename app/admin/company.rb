ActiveAdmin.register Company do
	config.sort_order = "id_asc"
	include_import
	index do
		column :name
		column :short_hand
		column :logo
		column "Active", :status
		actions :defaults => true
	end
  
end
