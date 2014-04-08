ActiveAdmin.register SumInsured do
	config.sort_order = "id_asc"
  include_import
  preserve_default_filters!
  filter :policy, :collection => proc {(AgeBracket.all).map{|c| [c.range, c.id]}}

  menu :parent => "Age Brackets"
  
end
