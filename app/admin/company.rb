ActiveAdmin.register Company do
	config.sort_order = "id_asc"
	include_import
	menu :priority => 1
	permit_params :name,:logo, :status

	#Scopes
	scope :all, default: true
	scope :active

	#Filters
	preserve_default_filters!
	remove_filter :regions
	remove_filter :logo
	remove_filter :status
	remove_filter :products

	#Default Actions
	actions :all, :except => [:destroy]

	index do
		column "Company Name", :name 
		column "Logo" do |c|
      image_tag(c.logo.url())
		end
		column :status do |c|
			if c.status
				status_tag("Active", :ok)
			else
				status_tag("Deactive")
			end
		end
		actions defaults: false, dropdown: true, dropdown_name: "Company Actions" do |c|
			item("View Company Details", admin_company_path(c))
			item("Edit Company Details", edit_admin_company_path(c))
			item("Active/Deactive Company", deactive_admin_company_path(c))
			item("Add Provinces", add_admin_region_path(id: c.id, name: c.name))
		end

		column "", class: "col-btn-group" do |c|
			dropdown_menu "In-Bound Product" do 
				item("View Visitor Policy", admin_products_path(q: {company_id_eq: c.id, policy_type_equals: "Visitor Visa"}))
				item("View All Inclusive Policy", admin_products_path(q: {company_id_eq: c.id, policy_type_equals: "Visitor All Inclusive"}))
				item("View Student Policy", admin_products_path(q: {company_id_eq: c.id, policy_type_equals: "Student Visa"}))
				item("View Ex-Pat Policy", admin_products_path(q: {company_id_eq: c.id, policy_type_equals: "Ex-Pat"}))
				item("Add Visitor Policy", new_admin_product_path(id: c.id, name: c.name, p_type: "Visitor Visa"))
				item("Add Student Policy", new_admin_product_path(id: c.id, name: c.name, p_type: "Student Visa"))
				item("Add Ex-Pat Policy", new_admin_product_path(id: c.id, name: c.name, p_type: "Ex-Pat"))
				item("Add All Inclusive Policy", new_admin_product_path(id: c.id, name: c.name, p_type: "Visitor All Inclusive"))
			end
			dropdown_menu "Out-Bound Products" do
   		 	item("View", "#")
			end
		end
	end
	
	#Form
	form do |f|
		f.inputs do
			f.input :name, label: "Company name"
			f.input :logo, :as => :file
			f.input :status, :as => :radio, :collection => [['Active', true], ['Not', false]]
		end
		f.actions
	end

	#Show
	show do |c|
		div class: "show_left" do
			attributes_table do
	      row "Logo" do |c|
      		image_tag(c.logo.url())
				end
	      row :status do |c|
					if c.status
						status_tag("Active", :ok)
					else
						status_tag("Deactive")
					end
				end
    	end
    	
			panel("Visitor Products", class: 'group single_show') do
				if c.products.any?
					ul do
						c.products.each do |p|
							li do
								attributes_table_for p do
									row "Policy Name" do |p|
										link_to "#{p.name}", admin_product_path(p)
									end
					        row :policy_number
					        row :description do |p|
					        	div class: 'des_flown' do
					        		text_node p.description.html_safe
					        	end

					        end
					        row :status do |p|
										if p.status
											status_tag("Active", :ok)
										else
											status_tag("Deactive")
										end
									end
									div class: "col-btn-group right" do 
										dropdown_menu "Policy Actions", class: "dropdown_menu" do
											item("View", admin_product_path(p))
											item("Edit", edit_admin_product_path(p))
											item("Delete", admin_product_path(p), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
										end	
										dropdown_menu "Policy Options", class: "dropdown_menu" do
											item("Add Version", new_admin_version_path(:id => p.id, name: p.name))
											item("Add Deductibles", new_admin_deductible_path(:id => p.id, name: p.name))
											item("Add Age Bracket", new_admin_age_bracket_path(:id => p.id, name: p.name))
											item("Select Product Filters", add_admin_product_filter_set_path(id: p.id, name: p.name))
											item("Add Legal Text", new_admin_legal_text_path(:id => p.id, name: p.name, e_date: p.effective_date.strftime("%Y-%m-%d")))
										end	
									end
					      end
					    end
						end
					end
				else
					div class: "no_list" do 
						text_node "<span>No Products Were Found For This Company, Create One!</span>".html_safe
					end
				end
				text_node button_to "Add Product", new_admin_product_path(), method: 'get', class: "right"
			end
		end

		div class: "show_right" do
			panel("Regions of Operations", class: 'group') do
				table_for c.provinces do
					column "" do |p|
						image_tag p.flag, size: "35x35"
					end
					column :name
					column :short_hand
					column "" do  |p|
						link_to "Remove Region", remove_admin_region_path(id: p.id, company_id: c.id), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}
					end
				end

				text_node link_to "Add/Remove Regions", add_admin_region_path(id: c.id), class: "link_button right"
			end if c.provinces
		end
	end
	#Actions
  member_action :deactive, method: :get do
  	@company = Company.find(params[:id])
  	if @company.status
    	@company.update(status: false)
    else
    	@company.update(status: true)
    end
    redirect_to :back
  end
end
