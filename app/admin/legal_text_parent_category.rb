ActiveAdmin.register LegalTextParentCategory do

  include_import

  menu :parent => "Global Settings"
  
  permit_params :name

  index do
    selectable_column
    column :name
    column :order
    column :popup_description
    actions defaults: true, dropdown: true
  end

  show do |l|
    attributes_table do
      row :name, :label => "Category Name"
      row :order
      row :popup_description do |l|
        l.popup_description() if l.popup_description
      end
    end
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