ActiveAdmin.register Product do
	config.sort_order = "id_asc"
	
	menu :priority => 2

	include_import
	permit_params :name, :product_number, :description, :company_id

	#Scopes
	scope :all, default: true
	scope :active
	scope :has_preex

	#Filters
	filter :company, :collection => -> { Company.all.map { |c| [c.name, c.id] } }
	preserve_default_filters!
	remove_filter :deductibles
	remove_filter :legal_texts
	remove_filter :age_brackets
	remove_filter :versions
	remove_filter :product_filter_sets
	remove_filter :description
	remove_filter :purchase_url

	#Index Table
	index do
		selectable_column
		column :name, :sortable => :name do |resource|
			editable_text_column resource, :name
		end

		column :product_number
		column "Company" do |p|
			image_tag("#{p.company.logo}",  style: "height: 60%" )
		end
		column "Versions", :class => "min-width-150" do |p|
			p.versions.map do |version| 
				link_to(version.detail_type.gsub("Detail", ""), admin_version_path(version)) 
			end.join(" | ").html_safe
		end
		column "Describition" do |p|
			p.description.html_safe() if p.description
		end
		column "After 30 Days", :can_buy_after_30_days
		column :preex
		column :status
		default_actions
	end

	show do |p|
		div class: "show_left" do
			attributes_table do
				row :product_number
				row :description do |p|
					p.description.html_safe() if p.description
				end
				row :preex do |a|
					if a.preex
						status_tag("Yes", :ok)
					else
						status_tag("No")
					end
				end
				row :status do |p|
					if p.status
						status_tag("Active", :ok)
					else
						status_tag("Not Active")
					end
				end
			end
			
			panel("Versions", class: 'group single_show') do
				ul do
					p.versions.each do |version|
						li do
							attributes_table_for version do
								row :type
								row :detail_type
				        row :status do |v|
									if v.status
										status_tag("Active", :ok)
										else
										status_tag("Not Active")
									end
								end
								row :min_age do |v|
									v.detail.min_age
								end		
								row :max_age do |v|
									v.detail.max_age
								end
								
								if version.detail_type == "Couple"
									row :has_couple_rate do |v|
										if v.has_special_rate?
											status_tag "Yes", :ok
										else
											status_tag "No"
										end
									end
								elsif version.detail_type == "Family"
									row :min_adult do |v| v.detail.min_adult end
									row :max_adult do |v| v.detail.max_adult end
									row :min_dependant do |v| v.detail.min_dependant end
									row :max_dependant do |v| v.detail.max_dependant end
									row :max_kids_age do |v| v.detail.max_kids_age end
								  row :max_age_with_kids do |v| v.detail.max_age_with_kids end
								  row :has_family_rate do |v|
										if v.has_special_rate?
											status_tag "Yes", :ok
										else
											status_tag "No"
										end
									end
								end
								text_node link_to "Edit", edit_admin_version_path(version), class: "link_button right"
								text_node link_to "View", admin_version_path(version), class: "link_button right"
				      end
	
				    end
					end
				end
				text_node link_to "Add New Version",  new_admin_version_path(:product_id => p.id, name: p.name), method: :get, class: "link_button right"
			end

			panel("Product Filters", class: 'group') do
				if p.product_filters
					table_for p.product_filters  do
						column :name
						column :policy_type
						column "" do |f|
							text_node link_to "Remove Filter", remove_admin_product_filter_set_path(id: f.id, product_id: p.id), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}
						end
					end
				end
				text_node link_to "Add/Remove Filters", add_admin_product_filter_set_path(id: p.id),  class: "link_button right"
			end 
		end

		div class: "show_right" do
			panel("Deductibles", class: 'group') do
				table_for p.deductibles.order((params[:order] || "amount_asc").gsub('_', ' ') ), 
				sortable: true  do
					column :amount, sortable: :amount
					column :mutiplier, sortable: false
					column :condition, sortable: false
				end
				text_node button_to "Add Deductible", new_admin_deductible_path, method: 'get', class: "right"
			end if p.deductibles
		end
		
	end

	form do |f|
		f.inputs do
			f.input :name
			f.input :product_number
			f.input :company_id, :as => :select, :collection => Company.all
			f.input :preex, :as => :select, :collection => [["Yes", true], ["No", false]]
			f.input :description, :as => :ckeditor

		end
		f.actions
	end

	#Actions
	member_action :remove_region, method: :delete do

	Region.where("province_id = ? AND company_id = ?", params[:province_id], params[:id]).each { |r| r.destroy }

		flash[:notice] = "Province was successfully removed!"
		redirect_to admin_company_path(params[:id])
	end
	

end
