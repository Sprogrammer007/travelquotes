ActiveAdmin.register Province do
	config.sort_order = "id_asc"
	include_import
  menu :parent => "Companies"
  
end
