ActiveAdmin.register Rate do
	config.sort_order = "id_asc"
	include_import

	#Scopes
	scope :all, default: true

	#Filters
	filter :age_bracket, :collection => proc { Rate.select_age_bracket_options }  
	filter :preex, :as => :select, :collection => [['Yes', 'true'], ['No', 'false']]
	remove_filter :preex
	preserve_default_filters!

	menu :parent => "Products"
	
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
		default_actions
	end

	#Form
	form do |f|
		f.inputs do
			f.input :age_bracket
			f.input :sum_insured
			f.input :preex
			f.input :effective_date, :as => :datepicker, :input_html => { :readonly => true } 
			f.input :rate
		end
		f.actions
	end

	controller do         
		def permitted_params             
			params.permit(:future => [:age_bracket_id, :rate_type, :sum_insured, :rate, :effective_date])     
		end     
	end
	#Actions
  member_action :add_future, method: :get do
    @page_title = "Add Future Rate"
    @age = AgeBracket.find(params[:id])
    render template: "admins/add_rate"
  end

  collection_action :create_future, method: :post do
	  if params[:future] 
	  	Rails.logger.warn ("#{permitted_params[:future]}")
	  	Rate.create(permitted_params[:future]) do |r|
	  		r.status = "Future"
	  	end
	  end
    redirect_to :back
  end


end
