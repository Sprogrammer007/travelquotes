ActiveAdmin.register RefundableText do
	config.sort_order = "id_asc"
	include_import
	preserve_default_filters!
	
	menu :parent => "Plans"
	
end
