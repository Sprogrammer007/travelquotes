ActiveAdmin.register LegalTextCategory do

  include_import

  menu :parent => "Global Settings"

  remove_filter :legal_texts

  permit_params :legal_text_parent_category_id, :name
  
  index do
    selectable_column
    column "Parent Category" do |l|
      l.legal_text_parent_category.name() if l.legal_text_parent_category()
    end
    column :name
    column :order
    column :popup_description
    actions defaults: true, dropdown: true
  end

  show do |l|
    attributes_table do
      row "Parent Category" do |l|
        l.legal_text_parent_category.name() if l.legal_text_parent_category()
      end
      row :name, :label => "Category Name"
      row :order
      row :popup_description do |l|
        l.popup_description() if l.popup_description
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :legal_text_parent_category
      f.input :name
      f.input :popup_description
    end
    f.actions
  end
  
  action_item do
    link_to("Sort Categories",  sort_admin_legal_text_categories_path()) 
  end

  #Actions
  collection_action :sort, method: :get do
    @page_title = "Sort Legal Text Categories"
    render template: "admins/sort_category"
  end

  collection_action :sort_update, method: :post do
    LegalTextParentCategory.update(params[:parents].keys, params[:parents].values)
    LegalTextCategory.update(params[:childs].keys, params[:childs].values)
    redirect_to :back
  end

end