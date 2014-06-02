ActiveAdmin.register Product do
	config.sort_order = "id_asc"
	
	menu :priority => 2, :label => "Visitor Policy"

	include_import

	permit_params :name, :policy_number, :description, :company_id, :min_price, :can_buy_after_30_days,
	:can_renew_after_30_days, :renewable_max_age, :preex_max_age, :preex, :preex_based_on_sum_insured,
	:purchase_url, :status,  deductibles_attributes: [:amount, :mutiplier, :condition, :age]

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
	index :title => "Visitor Policies" do
		selectable_column
		column :name, :sortable => :name do |resource|
			editable_text_column resource, :name
		end

		column :policy_number
		column "Company" do |p|
			p.company.name if p.company
		end
		column "Versions" do |p|
			dropdown_menu "Versions" do
				p.versions.map do |version| 
   		 		item(version.detail_type.gsub("Detail", ""), admin_version_path(version))
				end
			end
		end

		column :min_price
		column "After 30 Days", :can_buy_after_30_days
		column "Renew 30 Days", :can_renew_after_30_days
		column "Pre-Med", :preex
		column :status
		actions defaults: true, dropdown: true do |p|
			item  "Add Version", new_admin_version_path(:id => p.id, name: p.name)
			item  "Add Deductibles", new_admin_deductible_path(:id => p.id, name: p.name)
			item  "Add Age Bracket", new_admin_age_bracket_path(:id => p.id, name: p.name)
			item  "Add Product Filters", add_admin_product_filter_set_path(id: p.id)
			item  "Add Legal Text", new_admin_legal_text_path(:id => p.id, name: p.name)
		end
	end

	show :title => "Policy Details" do |p|
		div class: "show_left" do
			panel "Policy Eligibiliities" do
				attributes_table_for product do
					row :policy_number
					row :description do |p|
						p.description.html_safe() if p.description
					end
					row "Can The Policy Be Purchased After 30 Days Of Arrival?" do |p|
						if p.can_buy_after_30_days
							status_tag("Yes", :ok)
						else
							status_tag("No")
						end
					end
					row "Can The Policy Be Renewed After 30 Days Of Lapse" do |p|
						if p.can_renew_after_30_days
							status_tag("Yes", :ok)
						else
							status_tag("No")
						end
					end
					row :renewable_max_age
					row "Stable Pre-Existing Medical Condition" do |p|
						if p.preex
							status_tag("Yes", :ok)
						else
							status_tag("No")
						end
					end
					row :preex_max_age
					row "Are Pre-Existing Medical Condition Based On Sum Insured As Well?" do |p|
						if p.preex_based_on_sum_insured
							status_tag("Yes", :ok)
						else
							status_tag("No")
						end
					end
					row :purchase_url
					row :status do |p|
						if p.status
							status_tag("Active", :ok)
						else
							status_tag("Not Active")
						end
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
									v.detail.min_age() if v.detail
								end		
								row :max_age do |v|
									v.detail.max_age() if v.detail
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
								text_node link_to "Delete", admin_version_path(version), class: "link_button right", method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}
								text_node link_to "Edit", edit_admin_version_path(version), class: "link_button right"
								text_node link_to "View", admin_version_path(version), class: "link_button right"
				      end
	
				    end
					end
				end
				text_node link_to "Add New Version",  new_admin_version_path(:id => p.id, name: p.name), method: :get, class: "link_button right"
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

			panel("Legal Text", class: 'group') do
				if p.legal_texts
					table_for p.legal_texts  do
						column :name
						column :policy_type
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
      			column :effective_date
      			column "" do |l|
      				link_to("Remove", admin_legal_text_path(l.id), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
      			end
					end
				end
				text_node link_to "Add Legal Text", new_admin_legal_text_path(product_id: p.id),  class: "link_button right"
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
			if f.object.new_record? && !params[:id]
				f.input :company, :as => :select
			else
				f.input :company_id, :as => :hidden, :input_html =>  {value: params[:id]}
			end
			f.input :name
			f.input :policy_number
			f.input :description, :as => :ckeditor
			f.input :min_price
			f.input :can_buy_after_30_days, :as => :radio, :collection => [["Yes", true], ["No", false]]
			f.input :can_renew_after_30_days, :as => :radio, :collection => [["Yes", true], ["No", false]]
			f.input :renewable_max_age
			f.input :preex, :as => :radio, :collection => [["Yes", true], ["No", false]]
			f.input :preex_max_age
			f.input :preex_based_on_sum_insured, :as => :radio, :collection => [["Yes", true], ["No", false]]
			f.input :purchase_url
			f.input :status, :as => :radio, :collection => [['Active', true], ['Not Active', false]]
		end

		f.inputs do
			f.has_many :deductibles, :allow_destroy => true, :heading => 'Add Dedutibles' do |d|
				d.input :amount
				d.input :mutiplier
				d.input :condition, :as => :select, :collection => Deductible.conditions_options
				d.input :age
			end
		end
		f.actions
	end

	#Actions
	member_action :remove_region, method: :delete do

	Region.where("province_id = ? AND company_id = ?", params[:province_id], params[:id]).each { |r| r.destroy }

		flash[:notice] = "Province was successfully removed!"
		redirect_to admin_company_path(params[:id])
	end
	
	controller do
		def clean_params
			params.require(:product).permit(:name, :policy_number, :description, :min_price, :renewable_max_age,
			  :can_buy_after_30_days, :can_renew_after_30_days, :preex_max_age, :preex, :preex_based_on_sum_insured, :purchase_url,
				:status)
		end

	end

end
