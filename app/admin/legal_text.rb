ActiveAdmin.register LegalText do

  include_import

  menu :parent => "Super Admin"

  permit_params :product_id, :legal_text_category_id, :policy_type, :description,
  :effective_date, :status

  index :title => "Legal Text" do
    column "Product" do |l|
      l.product.name()
    end
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
  
  show :title => proc{ "LegalText For #{resource.product.name}" } do |l|
    attributes_table do
      row :product
      row "Parent Category" do |l|
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
      if f.object.new_record? && params[:id]
        f.input :product_id, :as => :hidden, input_html: { value: params[:id] }
        f.input :product, :as => :select, :collection => options_for_select([[params[:name], params[:id]]], params[:id]), 
        input_html: { disabled: true}
      else 
        f.input :product
      end
      if f.object.new_record?
        f.input :parent_category, :as => :select, :collection => options_for_select(LegalTextParentCategory.all.pluck(:name))
        f.input :legal_text_category_id, :as => :select, :collection => grouped_options_for_select(LegalTextCategory.category_selections)
        f.input :policy_type, :as => :select, :collection => options_for_select(["Visitor Visa", "Super Visa", "Both"])
        f.input :description, input_html: {value: "No Coverages", class: "tinymce"}
      else
        f.input :parent_category, :as => :select, :collection => options_for_select(LegalTextParentCategory.all.pluck(:name), f.object.legal_text_category.legal_text_parent_category.name), 
        input_html: { disabled: true}
        f.input :legal_text_category_id, :as => :select, :collection => grouped_options_for_select(LegalTextCategory.category_selections, f.object.legal_text_category.id), 
        input_html: { disabled: true}
        f.input :policy_type, :as => :select, :collection => options_for_select(["Visitor Visa", "Super Visa", "Both"], f.object.policy_type)
        f.input :description, input_html: {class: "tinymce"}
      end
      if f.object.new_record?
        f.input :effective_date, label: "Policy Effective date", :as => :datepicker, input_html: {value: params[:e_date]}
      else
        f.input :effective_date, label: "Policy Effective date", :as => :datepicker
      end
      f.input :status, :as => :select, :collection => [["Active", true], ["No Active", false]]
    end
    f.actions
  end

  controller do
    def create
      product = Product.find(params[:legal_text][:product_id])
      category_ids = product.legal_texts.pluck(:legal_text_category_id)
      if category_ids.include?(params[:legal_text][:legal_text_category_id].to_i)
        flash[:error] = "There is already a version of legal text for this category!"
        redirect_to admin_product_path(product)
      else
        super
      end
    end
    
    def destroy
      lt = LegalText.find(params[:id])
      id = lt.product.id
      lt.destroy
      redirect_to admin_product_path(id)
    end
  end
end