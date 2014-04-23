ActiveAdmin.register Product do
	config.sort_order = "id_asc"
	
	menu :parent => "Companies", :priority => 1

	include_import
	scope :all, default: true
	permit_params :name, :product_number, :description, :company_id

	#Filters
	filter :company, :collection => -> { Company.all.map { |c| [c.name, c.id] } }
	preserve_default_filters!
	remove_filter :plans
	remove_filter :deductibles
	remove_filter :product_filters

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
		column :can_buy_after_30_days
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
			panel("Products", class: 'group single_show') do
				ul do
					p.plans.each do |plan|
						li do
							attributes_table_for plan do
								row :type do |plan|
									link_to "#{plan.type}", admin_product_path(p)
								end
				        row :unique_id
				      end
				    end
					end
				end
				text_node button_to "Add Plan", new_admin_plan_path(), method: 'get', class: "right"
			end

			panel("Product Filters", class: 'group') do
				if p.product_filters
					table_for p.product_filters  do
						column :name
						column :category
						column :description  do |f|
							f.description.html_safe
						end
					end
				else
				end
				text_node button_to "Add Product Filter", new_admin_product_filter_path, method: 'get', class: "right"
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

end
