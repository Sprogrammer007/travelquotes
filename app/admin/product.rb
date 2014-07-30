ActiveAdmin.register Product do
	config.sort_order = "id_asc"
	
	menu false

	include_import

	permit_params :name, :policy_number, :pdf, :description, :policy_type, :company_id, :min_price, :can_buy_after_30_days,
	:can_renew_after_30_days, :renewable_max_age, :preex_max_age, :preex, :preex_based_on_sum_insured,
	:purchase_url, :rate_effective_date, :status, :effective_date, deductibles_attributes: [:amount, :mutiplier, :min_age, :max_age]

	#Scopes
	scope :all, default: true
	scope :active
	scope :has_preex

	#Filters
	filter :company, :collection => -> { Company.all.map { |c| [c.name, c.id] } }
	filter :policy_number
	filter :policy_type
	filter :effective_date
	filter :can_renew_after_30_days
	filter :can_buy_after_30_days


	#Index Table
	index do
		column "Company" do |p|
			p.company.name if p.company
		end
		column "Policy Name", :name, :sortable => :name do |resource|
			editable_text_column resource, :name
		end

		column :policy_number

		column "Versions", class: "col-btn-group col-versions" do |p|	
			p.versions.reverse.map do |version| 
				dropdown_menu "#{version.detail_type}", class: "dropdown_menu versions" do
					item("View", admin_version_path(version))
					item("Edit", edit_admin_version_path(version))
					item("Delete", admin_version_path(version), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
					item("Select Existing Age Bracket",  add_admin_age_set_path(id: version.id))
				end
			end	
		end
		column :policy_type
		column "Pre-Med", :preex
		column :status do |p|
			if p.status
				status_tag("Active", :ok)
			else
				status_tag("Deactive")
			end
		end

		column "Policy Options", class: "col-btn-group-verticale" do |p|
			dropdown_menu "View" do 
				item("View Policy Details", admin_product_path(p))
				item("View Policy Age Brackets", admin_age_brackets_path(product_id: p.id, q: {product_id_eq: p.id}))
				item("View Policy Legal Texts", view_admin_legal_texts_path(product_id: p.id))
				item("View Policy Deductibles", admin_deductibles_path(q: {product_id_eq: p.id}))			
			end
			dropdown_menu "Edit" do 
				item("Add Version", new_admin_version_path(:id => p.id, name: p.name))
				item("Add Deductibles", new_admin_deductible_path(:id => p.id, name: p.name))
				item("Add Age Bracket", new_admin_age_bracket_path(:id => p.id, name: p.name))
				item("Select Product Filters", add_admin_product_filter_set_path(id: p.id, name: p.name))
				item("Add Legal Text", new_admin_legal_text_path(:id => p.id, name: p.name))
				item("Add Future Rate", add_future_admin_rate_path(id: p.id))
				item("Edit Policy", edit_admin_product_path(p))
				item("Active/Deactive Policy", deactive_admin_product_path(p))
				item("Delete", admin_product_path(p), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
			end
		end
	end

	show :title => "Policy Details" do |p|
		div class: "top group" do
			div class: "show_left" do
				panel "Policy Eligibiliities" do
					attributes_table_for product do
						row :policy_number
						row :policy_type
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

						row "Current Rate Effective Date" do |p|
							p.rate_effective_date.strftime("%m %d %Y")
						end
						row :future_rate_effective_date do |p|
							if p.future_rate_effective_date
								p.future_rate_effective_date.strftime("%m %d %Y")
							else
								"No Future Rate"
							end
						end
						row "Update Current Effective Date" do |p|
							form_tag url_for(:controller => 'admin/rates', :action => 'update_effective_date') do
								[
									hidden_field_tag("product_id", p.id),
									text_field_tag("[current_effective_date]", nil, id: "future_rate_effective_date" , :placeholder => "Enter New Effective Date...", readonly: true),
									submit_tag("Update Current Rates")
								].join(" ").html_safe
							end
						end
						if product.future_rate_effective_date
							row "Update Current Effective Date" do |p| 
								form_tag url_for(:controller => 'admin/rates', :action => 'update_effective_date') do
									[
										hidden_field_tag("product_id", p.id),
										text_field_tag("[future_effective_date]", nil, id: "future_rate_effective_date" , :placeholder => "Enter New Future Effective Date...", readonly: true),
										submit_tag("Update Future Rates")
									].join(" ").html_safe
								end
							end
						end
						row "PDF" do |p|
							link_to("PDF", p.pdf.url())
						end
						row :status do |p|
							if p.status
								status_tag("Active", :ok)
							else
								status_tag("Deactive")
							end
						end
						row "Policy Effective Date" do |p|
							p.effective_date() if p.effective_date()
						end
					end
					text_node link_to "Add Future Rates", add_future_admin_rate_path(id: p.id),  class: "link_button right"
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
											status_tag("Deactive")
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
									dropdown_menu "Version Actions", class: "dropdown_menu right" do
										item("View", admin_version_path(version))
										item("Edit", edit_admin_version_path(version))
										item("Delete", admin_version_path(version), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
										item("Add Future Rates", add_future_admin_rate_path(id: version.id))
										item("Select Existing Age Bracket",  add_admin_age_set_path(id: version.id))
									end	
					      end
					    end
						end
					end
					text_node link_to "Add New Version",  new_admin_version_path(:id => p.id, name: p.name), method: :get, class: "link_button right"
				end
			end

			div class: "show_right" do
				panel("Deductibles", class: 'group') do
					table_for p.deductibles.order((params[:order] || "amount_asc").gsub('_', ' ') ), 
					sortable: true  do
						column :amount, sortable: :amount
						column :mutiplier, sortable: false
						column "Age Range" do |d|
							"#{d.min_age} - #{d.max_age}" if d.min_age()
						end
						column " " do |d|
							[
								link_to("View", admin_deductible_path(d)),
								link_to("Edit", edit_admin_deductible_path(d)),
		    				link_to("Remove", admin_deductible_path(d), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
	    				].join(" | ").html_safe
						end
					end
					text_node link_to "Add Deductible", new_admin_deductible_path(id: p.id, name: p.name), class: "link_button right"
				end if p.deductibles

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
					text_node link_to "Add/Remove Filters", add_admin_product_filter_set_path(id: p.id, name: p.name),  class: "link_button right"
				end 
			end
		end

		panel("Legal Text", class: 'group') do
			if p.legal_texts
				table_for p.legal_texts.joins(:legal_text_category => [:legal_text_parent_category]).order("legal_text_parent_categories.order asc") do
					column "Category" do |l|
      			l.legal_text_category.name() if l.legal_text_category()
    			end
					column :policy_type
					column :description, class: "lg_accordion" do |l|
						h3 do
							"Click to View Description"
						end
						div class: "full" do
							l.description.html_safe() if l.description
						end
					
					end
					column "Active" do |l|
		        if l.status
		          status_tag "Yes", :ok
		        else
		          status_tag "No"
		        end
    			end
    			column "" do |l|
    				[
							link_to("View", admin_legal_text_path(l)),
							link_to("Edit", edit_admin_legal_text_path(l)),
	    				link_to("Remove", admin_legal_text_path(l), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
    				].join(" | ").html_safe
    			end
				end
			end
			text_node link_to "Add Legal Text", new_admin_legal_text_path(:id => p.id, name: p.name),  class: "link_button right"
		end 
	end

	form do |f|
		f.inputs do
			if f.object.new_record? && params[:id]
				f.input :company_id, :as => :hidden, input_html: { value: params[:id] }
				f.input :company, :as => :select, :collection => options_for_select([[params[:name], params[:id]]], params[:id]), 
				input_html: { disabled: true}
			else
				f.input :company, :as => :select
			end
			f.input :name, label: "Policy Name"
			f.input :policy_number
			f.input :policy_type, :as => :select, :collection => options_for_select(["Visitor Visa", "Student Visa", "Ex-Pat"], (params[:p_type] || "Visitor Visa"))
			f.input :description, input_html: {class: "tinymce"}
			f.input :min_price
			f.input :can_buy_after_30_days, :as => :radio, :collection => [["Yes", true], ["No", false]]
			f.input :can_renew_after_30_days, :as => :radio, :collection => [["Yes", true], ["No", false]]
			f.input :renewable_max_age
			f.input :preex, :as => :radio, :collection => [["Yes", true], ["No", false]]
			f.input :preex_max_age
			f.input :preex_based_on_sum_insured, :as => :radio, :collection => [["Yes", true], ["No", false]]
			f.input :purchase_url
			if f.object.new_record?
				f.input :rate_effective_date, :label => "Current Rate Effective Date", :as => :datepicker
			end
			f.input :pdf, :as => :file, :label => "Policy PDF"
			f.input :effective_date, :label => "Policy Effective Date", :as => :datepicker
			f.input :status, :as => :radio, :collection => [['Active', true], ['Deactive', false]]
		end

		f.inputs do
			f.has_many :deductibles, :allow_destroy => true, :heading => 'Add Dedutibles' do |d|
				d.input :amount
				d.input :mutiplier
				d.input :min_age
				d.input :max_age
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
			params.require(:product).permit(:name, :policy_number, :pdf, :description, :min_price, :renewable_max_age,
			  :can_buy_after_30_days, :can_renew_after_30_days, :preex_max_age, :preex, :purchase_url,
				:preex_based_on_sum_insured,:rate_effective_date, :effective_date, :status, :policy_type)
		end

		def index 
			if params[:q]
				@page_title = "#{params[:q][:policy_type_equals]} Policies"
			else
				@page_title = "All Policies"
			end

			super
		end

		def new 
			@page_title = "New #{params[:p_type] || ""} Policy For #{params[:name]}"
			super
		end

		def update
			p = Product.find(params[:id])
			p.update(clean_params)
			if params[:product][:deductibles_attributes]
				params[:product][:deductibles_attributes].each_value do |attrs|
					if attrs[:_destroy] == '1'
						Deductible.find(attrs[:id]).destroy 
					elsif attrs[:id].nil?
						p.deductibles.create!(amount: attrs[:amount], mutiplier: attrs[:mutiplier],
							min_age: attrs[:min_age], max_age: attrs[:max_age])
					else
						Deductible.find(attrs[:id]).update(amount: attrs[:amount], mutiplier: attrs[:mutiplier],
							min_age: attrs[:min_age], max_age: attrs[:max_age])
					end
				end
			end
			redirect_to admin_product_path(p)
		end
	end

	#Actions
  member_action :deactive, method: :get do
  	@product = Product.find(params[:id])
  	if @product.status
    	@product.update(status: false)
    else
    	@product.update(status: true)
    end
    redirect_to :back
  end
end
