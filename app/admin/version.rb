ActiveAdmin.register Version do
	
	#Config
	menu :parent => "Products"
	include_import

	#Sorting
	config.sort_order = "id_asc"

	#Scopes
	scope :all, default: true
	scope :active
	
	#Filters
	preserve_default_filters!
	remove_filter :age_sets
	remove_filter :age_brackets

	permit_params :product_id, :type, :detail_type, :detail
	
	#Index
	index do 
		selectable_column
		column "Product" do |v|
			link_to v.product.name, admin_product_path(v.product_id)
		end
		column :type
		column :detail_type
		actions defaults: true, dropdown: true do |v|
			item  "Add Age Bracket",  add_admin_age_set_path(id: v.id)
		end
	end

	#Show
	show :title => proc{ resource.product.name + " (#{resource.type})" } do |v|
			attributes_table do
				row "Product" do |v|
					link_to v.product.name, admin_product_path(v.product_id)
				end
				row :type
				row :detail_type do |v|
					v.detail_type() if v.detail_type()
				end
			end

			panel("#{v.detail_type} Details", class: 'group single_show_version') do
				attributes_table_for v.detail do
					row :min_age
					row :max_age
					if v.detail_type == "Couple"
						row :has_couple_rate do |d|
							if d.has_couple_rate
								status_tag "Yes", :ok
							else
								status_tag "No"
							end
						end
					elsif v.detail_type == "Family"
						row :min_adult
						row :max_adult
						row :min_dependant
						row :max_dependant
						row :max_kids_age
					  row :max_age_with_kids
					  row :has_family_rate do |d|
							if d.has_special_rate?
								status_tag "Yes", :ok
							else
								status_tag "No"
							end
						end
					end
				end	
			end

			panel("Age Brackets", class: 'group single_show_version') do
				ul do
					v.age_brackets.order("min_age asc").each do |age|
						li do
							div class: "show_version_wrapper group" do
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
									column :rate_type
									column :sum_insured
									column :effective_date
									column :status do |r|
										status_tag r.status, "#{r.status.downcase}"
									end
								end
								text_node link_to "Delete", admin_age_bracket_path(age), class: "link_button right", method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}
								text_node link_to "Edit", edit_admin_age_bracket_path(age), class: "link_button right"
								text_node link_to "View", admin_age_bracket_path(age), class: "link_button right"
							end
						end
					end
				end
				text_node link_to "Add/Remove Age Brackets", add_admin_age_set_path(id: v.id),  class: "link_button right"
			end

	end

	#Form
	form do |f|
		f.inputs do
			if params[:id]
				f.input :product_id, :as => :hidden, input_html: { value: params[:id] }
				f.input :product, :as => :select, :collection => options_for_select([[params[:name], params[:id]]], params[:id]), 
				input_html: { disabled: true}
			else 
				f.input :product
			end
			f.input :type, :as => :select, :collection => options_for_select(Version.get_types, f.object.type)
			if f.object.new_record?
				f.input :detail_type, :as => :select, :collection => options_for_select(["Single", "Couple", "Family"], "Single"), 
					input_html: { class: "detail_type"}
			else
				f.input :detail_type, :as => :select, :collection => options_for_select(["Single", "Couple", "Family"], f.object.detail_type), 
					input_html: { class: "detail_type", :disabled => true	}
			end
		end
		if f.object.new_record?
			f.inputs "Family Version Details", :for => FamilyDetail.new, class: "family_details inputs hide" do |d|
				d.input :min_age
				d.input :max_age
				d.input :min_adult
				d.input :max_adult
				d.input :min_dependant
				d.input :max_dependant
				d.input :max_kids_age
				d.input :max_age_with_kids
				d.input :has_family_rate, :as => :radio, :collection => [["Yes", true], ["No", false]]
			end

			f.inputs "Couple Version Details", :for => CoupleDetail.new, class: "couple_details inputs hide" do |d|
				d.input :min_age
				d.input :max_age
				d.input :has_couple_rate, :as => :radio, :collection => [["Yes", true], ["No", false]]
			end

			f.inputs "Single Version Details", :for => SingleDetail.new, class: "single_details inputs" do |d|
				d.input :min_age
				d.input :max_age
			end
		else
			f.inputs "#{f.object.detail_type} Version Details", :for => f.object.detail, class: "inputs" do |d|
				d.input :min_age
			d.input :max_age
				if f.object.detail_type == "Family"
					d.input :min_adult
					d.input :max_adult
					d.input :min_dependant
					d.input :max_dependant
					d.input :max_kids_age
					d.input :max_age_with_kids
					d.input :has_family_rate, :as => :radio, :collection => [["Yes", true], ["No", false]]
				elsif f.object.detail_type == "Couple"
					d.input :has_couple_rate, :as => :radio, :collection => [["Yes", true], ["No", false]]
				end	
			end
		end
		f.actions
	end

	#Controller
	controller do

		def version_params             
			params.require(:version).permit(:product_id, :type, :detail_type, :detail,
				:family_detail => [:min_age, :max_age, :min_adult, :max_adult, :min_dependant, :max_dependant, :max_kids_age, :max_age_with_kids, :has_family_rate],
				:couple_detail => [:min_age, :max_age, :has_couple_rate],
				:single_detail => [:min_age, :max_age])        
		end     

		def destroy
			version = Version.find(params[:id])
			if version
				version.destroy_related
				flash[:notice] = "Version was successfully removed!"
			end
			redirect_to :back
		end

		def new
			@version = Version.new
		end

		def create
			version_type = version_params[:detail_type]
			details_params = version_params.delete(:"#{version_type.downcase}_detail")
			version = Version.new(:product_id => version_params[:product_id],
														:type => version_params[:type],
														:detail_type => version_params[:detail_type])
			if version.save
				"#{version_type}Detail".constantize.create!(details_params.merge(version: version))
				flash[:notice] = "Version were successfully created!"
				redirect_to admin_product_path(version_params[:product_id])
			else
				super
			end
		end

		def update
			version = Version.find(params[:id])
			version_type = "#{version.detail_type.downcase}_detail"
			details_params = version_params.delete(:"#{version_type}")
			if version
				version.update(:type => version_params[:type])
				version.detail.update(details_params)
				flash[:notice] = "Version were successfully updated!"
				redirect_to admin_version_path(params[:id])
			end
		end
	end

	#Actions
	batch_action :destroy, :confirm => "Are you sure you want to delete all of these?" do |selections|
		versions = Version.find(selections)
		versions.each { |version| version.destroy_related }
		flash[:notice] = "All versions were successfully removed!"
		redirect_to admin_versions_path
	end
end
