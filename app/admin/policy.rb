ActiveAdmin.register Policy do
  config.sort_order = "id_asc"
  menu :parent => "Companies"
  preserve_default_filters!
  filter :age_bracket, :collection => proc {(AgeBracket.all).map{|c| [c.policy_name, c.id]}}

  include_import
end
