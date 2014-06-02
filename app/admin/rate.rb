ActiveAdmin.register Rate do
	config.sort_order = "id_asc"
	include_import

<<<<<<< HEAD
=======
	permit_params :rate, :age_bracket_id, :sum_insured, :effective_date

>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
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
<<<<<<< HEAD
		default_actions
=======
		actions defaults: true, dropdown: true
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
	end

	#Form
	form do |f|
		f.inputs do
<<<<<<< HEAD
=======
			if params[:id]
				f.input :age_bracket_id, :as => :hidden, input_html: { value: params[:id] }
			else 
				f.input :age_bracket, as: :select, :collection => grouped_options_for_select(Rate.select_age_bracket_options) 
			end
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
			f.input :rate
			f.input :sum_insured
			f.input :effective_date, :as => :datepicker, :input_html => { :readonly => true } 
		end
		f.actions
	end

	controller do         
<<<<<<< HEAD
		def permitted_params             
=======
		def clean_params             
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
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
<<<<<<< HEAD
	  	Rails.logger.warn ("#{permitted_params[:future]}")
	  	Rate.create(permitted_params[:future]) do |r|
=======
	  	Rate.create(clean_params[:future]) do |r|
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
	  		r.status = "Future"
	  	end
	  end
    redirect_to :back
  end


end
