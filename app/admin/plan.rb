ActiveAdmin.register Plan do
	permit_params :type, :product_id

	#Config
	menu :priority => 2
	include_import

	#Sorting
	config.sort_order = "id_asc"

	#Filters
	preserve_default_filters!
	remove_filter :age_sets
	remove_filter :plan_filter_sets

	#Index
	index do 
		selectable_column
		column :id
		column :unique_id
		column :type
		column :status do |p|
			if p.status
				status_tag("Active", :ok)
			else
				status_tag("Not Active")
			end
		end
		default_actions
	end

	#Show
	show :title => proc{ resource.product.name + " (#{resource.type})" } do |p|

		div class: "show_left" do

			attributes_table do
				row "Product" do |p|
					p.product.name
				end
				row :type
				row :unique_id 
				row :status do |p|
					if p.status
						status_tag("Active", :ok)
						else
						status_tag("Not Active")
					end
				end
				
			end
			panel("Age Brackets", class: 'group single_show_plan') do
				ul do
					p.age_brackets.each do |age|
						li do
							div class: "show_plan_wrapper" do
								attributes_table_for age  do
									row :range
					      end
					      table_for age.rates do
					      	column :rate
					      	column :sum_insured
					      	column :preex do |r|
										if r.preex
											status_tag("Yes", :ok)
										else
											status_tag("No")
										end
									end
					      end
					    end
				    end
					end
				end
				text_node button_to "Add Age Bracket", new_admin_plan_path(), method: 'get', class: "right"
			end

			panel("Plan Filters", class: 'group') do
				if p.plan_filters
					table_for p.plan_filters  do
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
		
			end 
		end
	end

	#Form
	form do |f|
		f.inputs do
			f.input :product
			f.input :type, :as => :select, :collection => Plan.get_types
		end
		f.inputs do
			f.has_many :age_brackets, :heading => 'Add Age Brackets'  do |fa|
				fa.input :min_age
				fa.input :max_age

	
			end
		end
		f.actions
	end

	#Controller
	controller do         
	 	def permitted_params             
	 		params.permit!        
	 	end     

	 	def destroy
	 		plan = Plan.find(params[:id])
	 		if plan
	 			plan.destroy_related
	 			flash[:notice] = "Plan was successfully removed!"
	 		end
	 	
	 		redirect_to admin_plans_path
	 	end
	end

	batch_action :destroy, :confirm => "Are you sure you want to delete all of these?" do |selections|
		plans = Plan.find(selections)
		plans.each { |plan| plan.destroy_related }
		flash[:notice] = "All plans were successfully removed!"
		redirect_to admin_plans_path
	end
end
