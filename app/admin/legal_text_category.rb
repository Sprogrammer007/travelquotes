ActiveAdmin.register LegalTextCategory do

  include_import

  menu :parent => "Super Admin", :if => proc{ current_admin_user.email == "stevenag006@hotmail.com" }
  index do
    selectable_column
    column "Parent Category" do |l|
      l.legal_text_parent_category.name() if l.legal_text_parent_category()
    end
    column :name
    column :order
    actions defaults: true, dropdown: true
  end
end