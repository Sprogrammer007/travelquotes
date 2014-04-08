ActiveAdmin.register Policy do
  config.sort_order = "id_asc"
  menu :parent => "Companies"
  filter :age_bracket, :collection => proc {(AgeBracket.all).map{|c| [c.policy_name, c.id]}}

  include_import
end
