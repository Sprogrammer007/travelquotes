ActiveAdmin.register Plan do
	
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
		column :unique_id
		column :type
		column :detail_type
		column :can_buy_after_30_days
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
				row :detail_type do |p|
					p.detail_type.gsub("Detail", "")
				end
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
									row "Trip Duration" do |a|
										"#{a.min_trip_duration} - #{a.max_trip_duration} (Days)"
									end
									row :preex do |a|
										if a.preex
											status_tag("Yes", :ok)
										else
											status_tag("No")
										end
									end
								end
								table_for age.rates do
									column :rate
									column :sum_insured
								end
							end
						end
					end
				end
				text_node link_to "Add/Remove Age Brackets", add_admin_age_set_path(id: p.id),  class: "link_button right"
			end

		end

		div class: "show_right" do
			panel("Plan Filters", class: 'group') do
				if p.plan_filters
					table_for p.plan_filters  do
						column :name
						column :policy_type
						column "" do |f|
							text_node link_to "Remove Filter", remove_admin_plan_filter_set_path(id: f.id, plan_id: p.id), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}
						end
					end
				end
				text_node link_to "Add/Remove Filters", add_admin_plan_filter_set_path(id: p.id),  class: "link_button right"
			end 
		end
	end

	#Form
	form do |f|
		f.inputs do
			if params[:id]
				f.input :product, :as => :hidden, :input_html => { :value => params[:id] }
			else 
				f.input :product
			end
			f.input :type, :as => :select, :collection => Plan.get_types
			f.input :detail_type, :as => :select, :collection => ["Single", "Couple", "Family"], input_html: { class: "detail_type"	}

		end

		f.inputs "Family Plan Details", :for => FamilyDetail.new, class: "family_details inputs hide" do |detail|
			detail.input :min_dependant
			detail.input :max_dependant
			detail.input :max_kids_age
			detail.input :max_age_with_kids
		end

		f.inputs "Couple Plan Details", :for => CoupleDetail.new, class: "couple_details inputs hide" do |detail|
		end
		f.inputs "Single Plan Details", :for => CoupleDetail.new, class: "single_details inputs hide" do |detail|
		end
		f.actions
	end

	#Controller
	controller do     
		def plan_params             
			params.require(:plan).permit(:product_id, :type, :detail_type, 
				:family_detail => [:min_dependant, :max_dependant, :max_kids_age, :max_age_with_kids])        
		end     

		def destroy
			plan = Plan.find(params[:id])
			if plan
				plan.destroy_related
				flash[:notice] = "Plan was successfully removed!"
			end
		
			redirect_to admin_plans_path
		end

		def create
			plan_type = plan_params[:detail_type]
			details_params = plan_params.delete(:"#{plan_type.downcase}_detail")
			plan = Plan.new(plan_params.select { |k,v| k != "#{plan_type.downcase}_detail" })
			if plan.save
				"#{plan_type}Detail".constantize.create!(details_params.merge(plan: plan))
				flash[:notice] = "Plan were successfully created!"
				redirect_to admin_plan_path(plan)
			end
		end
	end

	#Actions
	batch_action :destroy, :confirm => "Are you sure you want to delete all of these?" do |selections|
		plans = Plan.find(selections)
		plans.each { |plan| plan.destroy_related }
		flash[:notice] = "All plans were successfully removed!"
		redirect_to admin_plans_path
	end
end
