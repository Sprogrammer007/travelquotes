ActiveAdmin.register Rate do
	config.sort_order = "id_asc"
	include_import

	permit_params :rate, :rate_type, :age_bracket_id, :sum_insured, :effective_date

	#Scopes
	scope :all, default: true

	#Filters
	filter :age_bracket, :collection => proc { Rate.select_age_bracket_options }  
	filter :preex, :as => :select, :collection => [['Yes', 'true'], ['No', 'false']]
	remove_filter :preex
	preserve_default_filters!

	menu :parent => "Super Admin"
	
	#Index Table
	index do
		selectable_column
		column :rate
		column :rate_type
		column :sum_insured
		column :status do |r|
			status_tag r.status, "#{r.status.downcase}"
		end
		column :effective_date
		actions defaults: true, dropdown: true
	end

	show :title => proc{ "Rate for " + resource.age_bracket.product.name + "(#{resource.age_bracket.range})" } do |r|
		attributes_table do
			row "Product" do |r|
				r.age_bracket.product.name
			end
			row "Age Bracket" do |r|
				r.age_bracket.range
			end
			row :rate
			row :rate_type
			row :sum_insured
			row :effective_date
			row :status
		end
	end

	#Form
	form do |f|
		f.inputs do
			if f.object.new_record? && params[:id]
				f.input :age_bracket_id, :as => :hidden, input_html: { value: params[:id] }
				f.input :age_bracket, as: :select, :collection => grouped_options_for_select(Rate.select_age_bracket_options, params[:id]), 
				input_html: { disabled: true} 
			else 
				f.input :age_bracket, as: :select, :collection => grouped_options_for_select(Rate.select_age_bracket_options, f.object.age_bracket_id) 
			end
			f.input :rate
			f.input :rate_type, as: :select, :collection => options_for_select(Rate.rate_types, f.object.rate_type) 
			f.input :sum_insured
		end
		f.actions
	end

	controller do         
		def clean_params             
			params.permit(:utf8, :authenticity_token, :commit, :effective_date, :future => [:age_bracket_id, :rate_type, :sum_insured, :rate, :effective_date])     
		end

		def new
			@age = AgeBracket.find(params[:id])
			@page_title = "New Rate For #{@age.product.name}"
			super
		end

		def edit 
			@page_title = "Edit Rate For #{resource.age_bracket.product.name}(#{resource.age_bracket.range})"
		end     
	end
	
	#Actions
  member_action :add_future, method: :get do
  	@version = Version.find(params[:id])
    @ages = @version.age_brackets
    @page_title = "Add Future Rates For #{@version.product.name}(#{@version.detail_type})"
    render template: "admins/add_rate"
  end

  collection_action :create_future, method: :post do
  	effective_date = clean_params[:effective_date]
  	if effective_date.empty?
  		flash[:error] = "Future effective date cannot be blank"
	  else
	  	Rate.create(clean_params[:future]) do |r|
	  		r.effective_date = effective_date
	  		r.status = "Future"
	  	end
		end
 		redirect_to :back
  end


end
