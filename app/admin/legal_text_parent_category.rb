ActiveAdmin.register LegalTextParentCategory do

  include_import

  menu :parent => "Global Settings"
  
  permit_params :name

  index do
    selectable_column
    column :name
    column :order
    actions defaults: true, dropdown: true
  end

  action_item do
    link_to("Sort Categories",  sort_admin_legal_text_categories_path()) 
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end