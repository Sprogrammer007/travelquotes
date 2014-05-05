ActiveAdmin.register AgeBracket do
	menu :parent => "Plans"
	config.sort_order = "id_asc"
	include_import

	#Scopes
	scope :all, default: true
	scope :has_pre_existing_medicals

	#Filters
	preserve_default_filters!
	filter :product
	filter :plans, :collection => -> {AgeBracket.plans_filter_selection}

	remove_filter :age_sets
	remove_filter :rates
	remove_filter :preex

	index do
		selectable_column
		column :range
		column :min_age
		column :max_age
		column :preex
		column :min_trip_duration
		column :max_trip_duration
		default_actions
	end

	index :as => :grid do |age|
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
				row " " do |a|
					[
						link_to("View", admin_age_bracket_path(a)),
						link_to("Edit", edit_admin_age_bracket_path(a)),
						link_to("Delete", admin_age_bracket_path(a), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}),
						link_to("Add Rate", add_future_admin_rate_path(id: a.id))
					].join(" | ").html_safe
				end
				
				table_for age.rates.current do
					column :rate
					column :rate_type
					column :sum_insured
					column :effective_date do |r|
						r.effective_date.strftime("%d, %m, %Y") if r.effective_date
					end
					column :status do |r|
						if r.status == "OutDated"
							status_tag "OutDated"
						else
							status_tag r.status, :ok
						end
					end
				end
			end
		end
	end

	form do |f|
		f.inputs do
			if params[:id]
				f.input :product, :as => :hidden, :input_html => { :value => Plan.find(params[:id]).product_id }
				f.input :plans, :as => :hidden, :input_html => { :value => params[:id] }
			else
				f.input :product,	:input_html => { :class => 'tier1_select' }
			end
			f.input :range
			f.input :min_age
			f.input :max_age
			f.input :min_trip_duration
			f.input :max_trip_duration
			f.input :preex
		end

		f.inputs do
			f.has_many :rates, :allow_destroy => true, :heading => 'Add Rates' do |cf|
				cf.input :rate
				cf.input :rate_type, :as => :select, :collection => Rate.rate_types
				cf.input :sum_insured
				cf.input :effective_date, :as => :datepicker
			end
		end
		f.actions
	end

end
