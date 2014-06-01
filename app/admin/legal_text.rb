ActiveAdmin.register LegalText do

  include_import

  menu :parent => "Products"

  index do
    selectable_column
    column :policy_type
    column "Category" do |l|
      l.legal_text_category.name() if l.legal_text_category()
    end
    column :description do |l|
      l.description.html_safe() if l.description
    end
    column :effective_date
    column "Active" do |l|
      if l.status
        status_tag "Yes", :ok
      else
        status_tag "No"
      end
    end
    actions defaults: true, dropdown: true
  end

  action_item do
    link_to("Sort Categories",  sort_admin_legal_text_categories_path()) 
  end
  
  show do |l|
    attributes_table do
      row :product
      row "parent" do |l|
        l.legal_text_category.legal_text_parent_category.name() if l.legal_text_category()
      end
      row "Category" do |l|
        l.legal_text_category.name() if l.legal_text_category()
      end
      row :policy_type
      row :description do |l|
        l.description.html_safe() if l.description
      end
      row "Active" do |l|
        if l.status
          status_tag "Yes", :ok
        else
          status_tag "No"
        end
      end
      row :effective_date
    end
  end
      

  #Form
  form do |f|
    f.inputs do
      if params[:id]
        f.input :productduct_id, :as => :hidden, input_html: { value: params[:id] }
        f.input :product, :as => :select, :collection => options_for_select([[params[:name], params[:id]]], params[:id]), 
        input_html: { disabled: true}
      else 
        f.input :product
      end
      f.input :parent_category, :as => :select, :collection => options_for_select(LegalTextParentCategory.all.pluck(:name))
      f.input :legal_text_category_id, :as => :select, :collection => grouped_options_for_select(LegalTextCategory.category_selections)
      f.input :policy_type, :as => :select, :collection => ["Visitor Visa", "Student Visa", "Both"]
      f.input :description, :as => :ckeditor
      f.input :effective_date, :as => :datepicker
      f.input :status, :as => :select, :collection => [["Active", true], ["No Active", false]]
    end
    f.actions
  end

  controller do
    def destroy
      LegalText.find(params[:id]).destroy
      redirect_to :back
    end
  end
end