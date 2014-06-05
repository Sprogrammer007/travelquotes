ActiveAdmin.register Region do

	include_import

	menu :parent => "Super Admin", :if => proc{ current_admin_user.email == "stevenag006@hotmail.com" }

 
  #Controller
  controller do         
    def permitted_params             
      params.permit!        
    end   

    def create
      Region.where(company_id: params[:company_id]).delete_all
      if params[:region_ids]
        ids = params[:region_ids].map { |id| {:province_id => id }}
        Region.create(ids) do |a|
          a.company_id = params[:company_id]
        end
        flash[:notice] = "Successfully updated regions!"
      end
      redirect_to admin_company_path(params[:company_id])
    end
  end

  #Actions
  member_action :add, method: :get do
    @page_title = "Select Regions For #{params[:name]}"
    company = Company.find(params[:id])
    @provinces = Province.all
    @already_selected_region = company.provinces.pluck(:id)
    render template: "admins/add_region"
  end

  member_action :remove, method: :delete do
    Region.where("province_id = ? AND company_id = ?", params[:id], params[:company_id]).delete_all

    flash[:notice] = "Province was successfully removed!"
    redirect_to :back
  end
end
