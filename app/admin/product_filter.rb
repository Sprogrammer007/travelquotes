ActiveAdmin.register ProductFilter do
	config.sort_order = "id_asc"
	config.paginate = false
	include_import

	permit_params :category, :name, :policy_type, :associated_lt_id, :descriptions, :sort_order

 	#Scopes
 	scope :all, default: true

	#Filters
	filter :category
  filter :name

	menu :parent => "Global Settings", :label => "Global Product Filters"

	index :title => "Global Product Filters" do
		selectable_column
		column :name
		column :category
		column"Associated LegalText Category" do |pf|
      pf.legal_text_category.name() if pf.legal_text_category()
     end
		column :descriptions do |p|
			p.descriptions.html_safe() if p.descriptions
		end
		actions defaults: true, dropdown: true
	end
	
	show do |pf|
		 attributes_table do
      row :name
      row :category
      row :policy_type
      row "Associated LegalText Category" do |pf|
      	pf.legal_text_category.name() if pf.legal_text_category()
      end
      row :descriptions do |pf|
        pf.descriptions.html_safe() if pf.descriptions()
      end
    end
	end
	form do |f|
		f.inputs do
			f.input :name
      f.input :sort_order
			f.input :category, :as => :select, :collection => options_for_select(ProductFilter.filter_categories.map(&:upcase), f.object.category)
			f.input :policy_type, :as => :select, :collection => options_for_select(["Visitor Visa", " Super Visa", "Both"], f.object.policy_type)
			f.input :associated_lt_id, :lebal => "Associated LegalText Category", :as => :select, :collection => options_for_select(LegalTextCategory.all.map { |l| [l.name, l.id] })
			f.input :descriptions, input_html: { class: "tinymce" }
		end
		f.actions
	end
end
