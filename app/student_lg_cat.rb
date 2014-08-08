ActiveAdmin.register StudentLgCat do

  include_import

  menu :parent => "Global Settings"

  remove_filter :student_legal_texts

  permit_params :student_lg_cat_id, :name
  
  index do
    selectable_column
    column "Parent Category" do |l|
      l.student_lg_parent_cat.name() if l.student_lg_parent_cat()
    end
    column :name
    column :order
    column :popup_description
    actions defaults: true, dropdown: true
  end

  show do |l|
    attributes_table do
      row "Parent Category" do |l|
        l.student_lg_parent_cat.name() if l.student_lg_parent_cat()
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
      f.input :student_lg_parent_cat
      f.input :name
      f.input :popup_description
    end
    f.actions
  end
  
  action_item do
    link_to("Sort Categories",  sort_admin_student_student_lg_cats_path()) 
  end

  #Actions
  collection_action :sort, method: :get do
    @page_title = "Sort Legal Text Categories"
    render template: "admins/sort_category"
  end

  collection_action :sort_update, method: :post do
    StudentLgParentCat.update(params[:parents].keys, params[:parents].values)
    StudentLgCat.update(params[:childs].keys, params[:childs].values)
    redirect_to :back
  end

end