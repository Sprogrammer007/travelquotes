ActiveAdmin.register AgeBracket do
	menu :parent => "Super Admin"
	config.sort_order = "id_asc"
	config.action_items.delete_if { |item|
	  item.display_on?(:index)
  }
	include_import

	permit_params(:product_id, :min_age, :max_age, :min_trip_duration, :max_trip_duration, :preex,
    rates_attributes: [:rate, :rate_type, :sum_insured, :effective_date],
    all_inclusive_rates_attributes: [:rate, :rate_type, :sum_insured, :min_date, :max_date, :min_trip_cost,
     :rate_trip_value])

  #Scopes
	scope :all, default: true
	scope :preex
	#Filters
	preserve_default_filters!
	filter :product
	filter :versions, :collection => -> {AgeBracket.versions_filter_selection}
	remove_filter :age_sets
	remove_filter :rates
	remove_filter :all_inclusive_rates
	remove_filter :preex


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
		div class: "custom_grid_index group" do
			attributes_table_for age  do
				row "Applied Versions" do |a|
					a.versions.map(&:detail_type).join(" | ")
				end
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
					if a.product.policy_type == "All Inclusive" && a.all_inclusive_rates.any?
						a.all_inclusive_rates.first.rate_type() 

					elsif a.rates.any?
						a.rates.first.rate_type() 
					end
				end
				row :effective_date do |a|
					a.product.rate_effective_date.strftime("%d, %m, %Y")
				end
				row " " do |a|
					[
						link_to("View", admin_age_bracket_path(id: a.id)),
						link_to("Edit", edit_admin_age_bracket_path(a)),
						link_to("Delete", admin_age_bracket_path(a), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}),
						link_to("Add Future Rate", add_future_admin_rate_path(id: a.product.id))
					].join(" | ").html_safe
				end
				
				if age.product.policy_type == "All Inclusive"
					table_for age.all_inclusive_rates.current.order("sum_insured ASC").order("rate_trip_value ASC") do 
						column :rate
						column "Date Range" do |r|
							"#{r.min_date} - #{r.max_date}"
						end
						column "Trip Cost Range" do |r|
      				"#{r.min_trip_cost} - #{r.rate_trip_value}"
    				end
						column :sum_insured
						column :status do |r|
							status_tag r.status, "#{r.status.downcase}"
						end
						column "" do |r|
							[
								link_to("Edit", edit_admin_all_inclusive_rate_path(r)),
								link_to("Delete", admin_all_inclusive_rate_path(r), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}),
							].join(" | ").html_safe
						end
					end
			
				else
					table_for age.rates.current.order("sum_insured ASC") do
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
			text_node(link_to("Add Rate", new_admin_all_inclusive_rate_path(id: age.id), class: "right link_button"))
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

		if a.product.policy_type == "All Inclusive"
			panel("Current Rates", class: "group") do 
				table_for a.all_inclusive_rates.current do
					column :rate
					column :rate_type
					column :sum_insured
					column :status do |r|
						status_tag r.status, "#{r.status.downcase}"
					end
					column "" do |r|
						[	
							link_to("Edit", edit_admin_all_inclusive_rate_path(r)),
							link_to("Remove", admin_all_inclusive_rate_path(r), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')} )
						].join(" | ").html_safe
					end
					
				end	

				if a.product.policy_type == "All Inclusive"
					text_node link_to "Add All Inclusive Rate",new_admin_all_inclusive_rate_path(id: a.id), class: "link_button right"
				else
					text_node link_to "Add Rate",new_admin_rate_path(id: a.id), class: "link_button right"
				end
			end

			panel("Future Rates", class: "group") do 
				table_for a.all_inclusive_rates.future do
					column :rate
					column :rate_type
					column :sum_insured
					column :status do |r|
						status_tag r.status, "#{r.status.downcase}"
					end
					column "" do |r|
						[	
							link_to("Edit", edit_admin_all_inclusive_rate_path(r)),
							link_to("Remove", admin_all_inclusive_rate_path(r), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')} )
						].join(" | ").html_safe
					end
					
				end	
			end

			panel("OutDated Rates", class: "group") do 
				table_for a.all_inclusive_rates.outdated do
					column :rate
					column :rate_type
					column :sum_insured
					column :status do |r|
						status_tag r.status, "#{r.status.downcase}"
					end
					column "" do |r|
						[	
							link_to("Edit", edit_admin_all_inclusive_rate_path(r)),
							link_to("Remove", admin_all_inclusive_rate_path(r), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')} )
						].join(" | ").html_safe
					end
				end	
			end
		else
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
	end

	form do |f|
		f.inputs do
			if f.object.new_record? && params[:id]
				f.input :product_id, :as => :hidden, :input_html => { :value => params[:id] }
				f.input :product_id, :as => :select, :collection => options_for_select([[params[:name], params[:id]]], params[:id]), input_html: { disabled: true, multiple: false}
			elsif f.object.new_record?
				f.input :product_id, :as => :hidden, :input_html => { :value => f.object.product_id }
				f.input :product, :as => :select, :collection => options_for_select(Product.all.map{ |p| [p.name, p.id]}, f.object.product_id),	:input_html => { :class => 'tier1_select' }
			else
				f.input :product_id, :as => :hidden, :input_html => { :value => f.object.product_id }
				f.input :product, :as => :select, :collection => options_for_select(Product.all.map{ |p| [p.name, p.id]}, f.object.product_id),	:input_html => { :class => 'tier1_select', disabled: true}
			end
			f.input :min_age
			f.input :max_age
			f.input :min_trip_duration
			f.input :max_trip_duration
			f.input :preex, :as => :radio, :collection => [["Yes", true], ["No", false]]
		end

		if f.object.new_record?
			if params[:policy_type] == "All Inclusive" 	
				f.inputs do
					f.has_many :all_inclusive_rates, :allow_destroy => true, :heading => 'Add All Inclusive Rates' do |cf|
						cf.input :rate
						cf.input :rate_type, :as => :select, :collection => AllInclusiveRate.rate_types
						cf.input :min_date
						cf.input :max_date
						cf.input :min_trip_cost
						cf.input :rate_trip_value, label: "Max Trip Cost"
						cf.input :sum_insured
						cf.input :status, :as => :select, :collection => options_for_select(["Current", "Future", "OutDated"])
					end
				end
			else
				f.inputs do
					f.has_many :rates, :allow_destroy => true, :heading => 'Add Rates' do |cf|
						cf.input :rate
						cf.input :rate_type, :as => :select, :collection => Rate.rate_types
						cf.input :sum_insured
						cf.input :status, :as => :select, :collection => options_for_select(["Current", "Future", "OutDated"], (cf.object.status || "Current"))
					end
				end
			end
		else
			if f.object.product.policy_type == "All Inclusive"
				f.inputs do
					f.has_many :all_inclusive_rates, :allow_destroy => true, :heading => 'Add All Inclusive Rates' do |cf|
						cf.input :rate
						cf.input :rate_type, :as => :select, :collection => AllInclusiveRate.rate_types
						cf.input :min_date
						cf.input :max_date
						cf.input :min_trip_cost
						cf.input :rate_trip_value, label: "Max Trip Cost"
						cf.input :sum_insured
						cf.input :status, :as => :select, :collection => options_for_select(["Current", "Future", "OutDated"], (cf.object.status || "Current"))
					end
				end
			else
				f.inputs do
					f.has_many :rates, :allow_destroy => true, :heading => 'Add Rates' do |cf|
						cf.input :rate
						cf.input :rate_type, :as => :select, :collection => Rate.rate_types
						cf.input :sum_insured
						cf.input :status, :as => :select, :collection => options_for_select(["Current", "Future", "OutDated"], (cf.object.status || "Current"))
					end
				end
			end
		end

		f.actions
	end

	controller do


		def index
			@per_page = 9
			if params[:product_id]
				@page_title = "Age Brackets for #{Product.find(params[:product_id]).name}"
			end
			super
		end

		def create
			age = AgeBracket.new(:product_id => params[:age_bracket][:product_id], 
				:min_age => params[:age_bracket][:min_age], 
				:max_age => params[:age_bracket][:max_age], 
				:min_trip_duration => params[:age_bracket][:min_trip_duration], 
				:max_trip_duration => params[:age_bracket][:max_trip_duration], 
				:preex => params[:age_bracket][:preex])
			if age.save!
				if params[:age_bracket][:rates_attributes]
					params[:age_bracket][:rates_attributes].each_value do |attrs|
						age.rates.create!(rate: attrs[:rate], rate_type: attrs[:rate_type],
							sum_insured: attrs[:sum_insured], effective_date: attrs[:effective_date])
					end
				elsif params[:age_bracket][:all_inclusive_rates_attributes]
					params[:age_bracket][:all_inclusive_rates_attributes].each_value do |attrs|
						age.all_inclusive_rates.create!(rate: attrs[:rate], min_date: attrs[:min_date], max_date: attrs[:max_date], 
							rate_type: attrs[:rate_type], min_trip_cost: attrs[:min_trip_cost],
							rate_trip_value: attrs[:rate_trip_value], sum_insured: attrs[:sum_insured], 
							effective_date: attrs[:effective_date])
					end
				end
			end
			redirect_to admin_age_brackets_path(product_id: params[:age_bracket][:product_id], q: {product_id_eq: params[:age_bracket][:product_id]})
		end

		def show
	    @page_title = "Age Bracket (#{resource.range}) For #{resource.product.name}"
	    super
		end

		def destroy
			age = AgeBracket.find(params[:id])
			product = age.product
			age.destroy
			redirect_to admin_age_brackets_path(q: {product_id_eq: product.id})
		end

		def update
			age = AgeBracket.find(params[:id])
			age.update(:product_id => params[:age_bracket][:product_id], 
				:min_age => params[:age_bracket][:min_age], 
				:max_age => params[:age_bracket][:max_age], 
				:min_trip_duration => params[:age_bracket][:min_trip_duration], 
				:max_trip_duration => params[:age_bracket][:max_trip_duration], 
				:preex => params[:age_bracket][:preex])
			if params[:age_bracket][:rates_attributes]
				params[:age_bracket][:rates_attributes].each_value do |attrs|
					if attrs[:_destroy] == '1'
						Rate.find(attrs[:id]).destroy 
					elsif attrs[:id].nil?
						age.rates.create!(rate: attrs[:rate], rate_type: attrs[:rate_type],
																			sum_insured: attrs[:sum_insured], effective_date: attrs[:effective_date])
					else
						Rate.find(attrs[:id]).update(rate: attrs[:rate], rate_type: attrs[:rate_type],
																			sum_insured: attrs[:sum_insured], effective_date: attrs[:effective_date])
					end
				end
			elsif params[:age_bracket][:all_inclusive_rates_attributes]
				params[:age_bracket][:all_inclusive_rates_attributes].each_value do |attrs|
					if attrs[:_destroy] == '1'
						AllInclusiveRate.find(attrs[:id]).destroy 
					elsif attrs[:id].nil?
						age.all_inclusive_rates.create!(rate: attrs[:rate], min_date: attrs[:min_date], max_date: attrs[:max_date], 
							rate_type: attrs[:rate_type], min_trip_cost: attrs[:min_trip_cost], 
							rate_trip_value: attrs[:rate_trip_value], sum_insured: attrs[:sum_insured], 
							effective_date: attrs[:effective_date])
					else
						AllInclusiveRate.find(attrs[:id]).update(rate: attrs[:rate], min_date: attrs[:min_date], max_date: attrs[:max_date], 
							rate_type: attrs[:rate_type], min_trip_cost: attrs[:min_trip_cost], 
							rate_trip_value: attrs[:rate_trip_value], sum_insured: attrs[:sum_insured], 
							effective_date: attrs[:effective_date])
					end
				end

			end
				
			redirect_to admin_age_brackets_path(product_id: params[:age_bracket][:product_id], q: {product_id_eq: params[:age_bracket][:product_id]})
		end
	end	
end
