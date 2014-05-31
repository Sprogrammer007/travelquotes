ActiveAdmin.register LegalTextParentCategory do

  include_import

  menu :parent => "Super Admin", :if => proc{ current_admin_user.email == "stevenag006@hotmail.com" }

  index do
    selectable_column
    column :name
    column :order
    actions defaults: true, dropdown: true
  end
end