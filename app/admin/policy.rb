ActiveAdmin.register Policy do
  config.sort_order = "id_asc"
  menu :parent => "Companies"

  include_import
end
