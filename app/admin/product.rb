ActiveAdmin.register Product do
	config.sort_order = "id_asc"
	
	menu :parent => "Companies", :priority => 1

	include_import
	permit_params :name, :product_number, :description, :company_id

	#Scopes
	scope :all, default: true
	scope :active
	
	#Filters
	filter :company, :collection => -> { Company.all.map { |c| [c.name, c.id] } }
	preserve_default_filters!
	remove_filter :plans
	remove_filter :deductibles
	remove_filter :product_filters
	remove_filter :legal_texts

	#Index Table
	index do
		selectable_column
		column :name, :sortable => :name do |resource|
			editable_text_column resource, :name
		end

		column :product_number
		column "Company" do |p|
			image_tag("#{p.company.logo}")
		end
		column "Plans" do |p|
			p.plans.map do |plan| 
				link_to(plan.type, admin_plan_path(plan)) 
			end.join.html_safe
		end
		column "Describition" do |p|
			p.description.html_safe
		end
		
		column :status
		default_actions
	end

	show do |p|
		div class: "show_left" do
			attributes_table do
				row :product_number
				row :description do |p|
					p.description.html_safe
				end
				row :status do |p|
					if p.status
						status_tag("Active", :ok)
					else
						status_tag("Not Active")
					end
				end
			end
			
			panel("Plans", class: 'group single_show') do
				ul do
					p.plans.each do |plan|
						li do
							attributes_table_for plan do
								row :type
								row :detail_type
				        row :unique_id
				        row :status do |p|
									if p.status
										status_tag("Active", :ok)
										else
										status_tag("Not Active")
									end
								end
				      end
				    end
					end
				end
				text_node link_to "Add New Plan",  new_admin_plan_path(:id => p.id), method: :get, class: "link_button right"
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
			f.input :company_id, :as => :select,      :collection => Company.all
			f.input :description, :as => :ckeditor
		end

		f.actions
	end

	#Actions
	member_action :add_plan, method: :get do
		@plan = Plan.new
		render template: "admins/add_plan"
	end

	member_action :remove_region, method: :delete do

	Region.where("province_id = ? AND company_id = ?", params[:province_id], params[:id]).each { |r| r.destroy }

		flash[:notice] = "Province was successfully removed!"
		redirect_to admin_company_path(params[:id])
	end
	

end
