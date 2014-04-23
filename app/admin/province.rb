ActiveAdmin.register Province do
	config.sort_order = "id_asc"
	include_import
  menu :parent => "Companies"
  permit_params :name, :short_hand, :company_ids
  
  #Filters
	preserve_default_filters!
	remove_filter :regions

	#Form
	form do |f|
		f.inputs do
			f.input :companies, :as => :select, :input_html => { :multiple => false }
			f.input :name,  :wrapper_html => { class: "new_selection"} 
			f.input :short_hand
	
		end
		f.actions
	end

	#Custom controller
	collection_action :create_region, method: :post do
		c = Company.find(params[:province][:company_id])
		if params[:province][:from_existing] == "Yes"
			if Region.where("province_id = ? AND company_id = ?", params[:province][:existing_name], params[:province][:company_id]).any?
				flash[:error] = "You've already added this Province for this Company!"
			else
				c.regions.create!(:province_id => params[:province][:existing_name])
				flash[:notice] = "Province was successfully added!"
			end
				redirect_to admin_company_path(c)
		else

			p = c.provinces.create!(params[:province])
			flash[:notice] = "Province was successfully created!"
			redirect_to admin_company_path(c)
		end
	end


	#Custom Actions
	action_item :only => :show do
   link_to("Add #{province.class.name}", action: 'import')
  end
end
