ActiveAdmin.register Deductible do
	config.sort_order = "id_asc"
	include_import
	preserve_default_filters!

	menu :parent => "Super Admin"

  permit_params :product_id, :amount, :mutiplier, :condition, :age
  
  index do
    column "Product" do |d|
      d.product.name()
    end
    column "Deductible Amount", :amount
    column "Deductible Mutiplier", :mutiplier
    actions defaults: true, dropdown: true
  end

 #Show
  show :title => proc{ "Deductibles For " + resource.product.name } do |d|
    attributes_table do
      row "Product" do |d|
        link_to d.product.name, admin_product_path(d.product_id)
      end
      row "Deductible Amount" do |d|
        d.amount
      end
      row "Deductible Mutiplier" do |d|
        d.mutiplier
      end
    end
    text_node link_to "Add Another Deductible For #{d.product.name}", new_admin_deductible_path(id: d.product.id, name: d.product.name),  class: "link_button right"
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
      f.input :amount, :label => "Deductible Amount"
      f.input :mutiplier, :label => "Deductible Mutiplier"
    end
    f.actions
  end

  controller do 
    def new
      @page_title = "New Deductibles For #{params[:name]}" 
      super
    end
  end
end
