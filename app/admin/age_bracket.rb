ActiveAdmin.register AgeBracket do
	menu :parent => "Super Admin"
	config.sort_order = "id_asc"
	include_import

	permit_params :product_id, :min_age, :max_age, :min_trip_duration, :max_trip_duration,
    rates_attributes: [:rate, :rate_type, :sum_insured, :effective_date]
	
	#Scopes
	scope :all, default: true
	scope :preex
	#Filters
	preserve_default_filters!
	filter :product
	filter :versions, :collection => -> {AgeBracket.versions_filter_selection}
	remove_filter :age_sets
	remove_filter :rates

	# index do
	# 	selectable_column
	# 	column :range, :sortable => false 
	# 	column :min_age
	# 	column :max_age
	# 	column :min_trip_duration
	# 	column :max_trip_duration
	# 	column :preex
	# 	actions defaults: true, dropdown: true do |a|
	# 		item  "Add Rate",  new_admin_rate_path(id: a.id)
	# 	end
	# end

	index :as => :grid  do |age|
		div class: "custom_grid_index" do

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
				row "Rate Type" do |a|
					a.rates.first.rate_type()
				end
				row :effective_date do |a|
					a.product.rate_effective_date.strftime("%d, %m, %Y")
				end
				row " " do |a|
					[
						link_to("View", add_future_admin_rate_path(id: a.id)),
						link_to("Edit", edit_admin_age_bracket_path(a)),
						link_to("Delete", admin_age_bracket_path(a), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}),
						link_to("Add Future Rate", add_future_admin_rate_path(id: a.id))
					].join(" | ").html_safe
				end
				
				table_for age.rates.current do
					column :rate
					column :sum_insured
					column :status do |r|
						status_tag r.status, "#{r.status.downcase}"
					end
					column "" do |r|
						[
							link_to("Edit", edit_admin_rate_path(r)),
							link_to("Delete", admin_rate_path(r), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}),
						].join(" | ").html_safe
					end
				end
			end
		end
	end

	show do |a|
		attributes_table do
			row "Product" do |a|
					link_to a.product.name, admin_product_path(a.product_id)
			end
			row "Range" do |a|
				"#{a.min_age} - #{a.max_age}"
			end
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
			row "Current Rate Effective Date" do |a|
				a.product.rate_effective_date
			end
			row "Future Rate Effective Date" do |a|
				(a.product.future_rate_effective_date || "No Future Rate")
			end
		end

		panel("Current Rates", class: "group") do 
			table_for a.rates.current do
				column :rate
				column :rate_type
				column :sum_insured
				column :status do |r|
					status_tag r.status, "#{r.status.downcase}"
				end
				column "" do |r|
					[	
						link_to("Edit", edit_admin_rate_path(r)),
						link_to("Remove", admin_rate_path(r), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')} )
					].join(" | ").html_safe
				end
				
			end	
			text_node link_to "Add Rate",new_admin_rate_path(id: a.id), class: "link_button right"
		end

		panel("Future Rates", class: "group") do 
			table_for a.rates.future do
				column :rate
				column :rate_type
				column :sum_insured
				column :status do |r|
					status_tag r.status, "#{r.status.downcase}"
				end
				column "" do |r|
					[	
						link_to("Edit", edit_admin_rate_path(r)),
						link_to("Remove", admin_rate_path(r), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')} )
					].join(" | ").html_safe
				end
				
			end	
		end

		panel("OutDated Rates", class: "group") do 
			table_for a.rates.outdated do
				column :rate
				column :rate_type
				column :sum_insured
				column :status do |r|
					status_tag r.status, "#{r.status.downcase}"
				end
				column "" do |r|
					[	
						link_to("Edit", edit_admin_rate_path(r)),
						link_to("Remove", admin_rate_path(r), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')} )
					].join(" | ").html_safe
				end
			end	
		end
	end

	form do |f|
		f.inputs do
			if f.object.new_record? && params[:product_id]
				f.input :product_id, :as => :hidden, :input_html => { :value => Version.find(params[:product_id]).product_id }
				f.input :product_id, :as => :select, :collection => options_for_select([[params[:name], params[:product_id]]], params[:product_id]), input_html: { disabled: true, multiple: false}
			elsif f.object.new_record? && params[:id]
				f.input :product_id, :as => :hidden, :input_html => { :value => params[:id] }
				f.input :product_id, :as => :select, :collection => options_for_select([[params[:name], params[:id]]], params[:id]), input_html: { disabled: true, multiple: false}
			else
				f.input :product_id, :as => :hidden, :input_html => { :value => f.object.product_id }
				f.input :product, :as => :select, :collection => options_for_select(Product.all.map{ |p| [p.name, p.id]}, f.object.product_id),	:input_html => { :class => 'tier1_select', disabled: true}
			end
			f.input :min_age
			f.input :max_age
			f.input :min_trip_duration
			f.input :max_trip_duration
		end

		f.inputs do
			f.has_many :rates, :allow_destroy => true, :heading => 'Add Rates' do |cf|
				cf.input :rate
				cf.input :rate_type, :as => :select, :collection => Rate.rate_types
				cf.input :sum_insured
			end
		end
		f.actions
	end

	controller do

		def clean_params
			params.require(:age_bracket).permit(:min_age, :max_age, :min_trip_duration, :max_trip_duration)
		end

		def clean_rate_params
			params.require(:age_bracket).permit(:rates_attributes => [:rate, :rate_type, :sum_insured])
		end
		
		def index
			@per_page = 9
			if params[:product_id]
				@page_title = "Age Brackets for #{Product.find(params[:product_id]).name}"
			end
			super
		end

		def show
	    @page_title = "Age Bracket (#{resource.range}) For #{resource.product.name}"
	    super
		end

		def update
			age = AgeBracket.find(params[:id])
			age.update(clean_params)
			if params[:age_bracket][:rates_attributes]
				params[:age_bracket][:rates_attributes].each_value do |attrs|
					if attrs[:_destroy] == '1'
					Rate.find(attrs[:id]).destroy 
					else
					Rate.find(attrs[:id]).update(rate: attrs[:rate], rate_type: attrs[:rate_type],
																			sum_insured: attrs[:sum_insured], effective_date: attrs[:effective_date])
					end
				end
			end
			redirect_to admin_age_brackets_path(product_id: params[:age_bracket][:product_id], q: {product_id_eq: params[:age_bracket][:product_id]})
		end
	end	
end
