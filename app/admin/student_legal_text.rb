ActiveAdmin.register StudentLegalText do

  include_import

  # super admin parent
  menu :parent => "Super Admin"

  permit_params :student_product_id, :student_lg_cat_id,  :description, :status
  remove_filter :student_product

  index :title => "Legal Text" do
    column "Product" do |l|
      l.student_product.name()
    end
    column "Category" do |l|
      l.student_lg_cat.name() if l.student_lg_cat()
    end
    column :description do |l|
      l.description.html_safe() if l.description
    end
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
    link_to("Sort Categories",  sort_admin_student_lg_cats_path()) 
  end
  
  show :title => proc{ "LegalText For #{resource.student_product.name}" } do |l|
    attributes_table do
      row :student_product
      row "Parent Category" do |l|
        l.student_lg_cat.student_lg_parent_cat.name() if l.student_lg_cat()
      end
      row "Category" do |l|
        l.student_lg_cat.name() if l.student_lg_cat()
      end
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
    end
    text_node link_to "Add Another LegalText For #{l.student_product.name}", new_admin_student_legal_text_path(id: l.student_product.id, name: l.student_product.name),  class: "link_button right"
  end
      
  #Form
  form do |f|
    f.inputs do
      if f.object.new_record? && params[:id]
        f.input :student_product_id, :as => :hidden, input_html: { value: params[:id] }
        f.input :student_product, :as => :select, :collection => options_for_select([[params[:name], params[:id]]], params[:id]), 
        input_html: { disabled: true}
      else 
        f.input :student_product
      end
      if f.object.new_record?
        f.input :parent_category, :as => :select, :collection => options_for_select(StudentLgParentCat.all.pluck(:name))
        f.input :student_lg_cat_id, :as => :select, :collection => grouped_options_for_select(StudentLgCat.category_selections(params[:id]))
        f.input :description, input_html: {value: "No Coverages", class: "tinymce"}
      else
        f.input :parent_category, :as => :select, :collection => options_for_select(StudentLgParentCat.all.pluck(:name), f.object.student_lg_cat.student_lg_parent_cat.name), 
        input_html: { disabled: true}
        f.input :student_lg_cat_id, :as => :select, :collection => grouped_options_for_select(StudentLgCat.category_selections(f.object.student_product_id), f.object.student_lg_cat_id), 
        input_html: { disabled: true}
        f.input :description, input_html: {class: "tinymce"}
      end
      f.input :status, :as => :select, :collection => [["Active", true], ["No Active", false]]
    end
    f.actions
  end

  controller do
    def create
      product = StudentProduct.find(params[:student_legal_text][:student_product_id])
      lg = product.student_legal_texts.where(student_lg_cat_id: params[:student_legal_text][:student_lg_cat_id].to_i)
      if lg.any?
        flash[:error] = "There is already a version of legal text for this category!"
        redirect_to admin_student_product_path(product)
      else
        super
      end
    end


    def update 
      super do |format|
        redirect_to view_admin_student_legal_texts_path(student_product_id: resource.student_product_id)
        return
      end
    end
    
    def destroy
      super do |format|
        redirect_to :back and return
      end
    end
  end

  collection_action :view, method: :get do
    product = StudentProduct.find(params[:product_id])
    @page_title = "Legal Texts For #{product.name}"
    @lts = product.student_legal_texts.merge(StudentLegalText.ordered)
    render template: 'admins/view_student_legal_texts'
  end
  sidebar 'Filter Legal Texts', only: :view do
    render template: 'admins/view_student_legal_texts_sidebar'
  end
end