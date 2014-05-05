ActiveAdmin.register PlanFilterSet do

	include_import

	menu :parent => "Super Admin",  :if => proc{ current_admin_user.email == "stevenag006@hotmail.com" }

  #Controller
  controller do         
    def permitted_params             
      params.permit!        
    end   

    def destroy
      Region.where("company_id = ? AND province_id = ?", params[:company_id], params[:id])[0].destroy
      flash[:notice] = "Province successfully removed!"
      redirect_to :back
    end

    def create
      PlanFilterSet.where(plan_id: params[:plan_id]).delete_all
      if params[:filter_ids]
        ids = params[:filter_ids].map { |id| {:plan_filter_id => id }}
        PlanFilterSet.create(ids) do |a|
          a.plan_id = params[:plan_id]
        end
        flash[:notice] = "Successfully updated filters!"
      end
      redirect_to admin_plan_path(params[:plan_id])
    end
  end

  #Actions
  member_action :add, method: :get do
    @page_title = "Select Filters"
    plan = Plan.find(params[:id])
    @filters = PlanFilter.all
    @already_selected_filters = plan.plan_filters.pluck(:id)
    render template: "admins/add_filters"
  end

  member_action :remove, method: :delete do
    PlanFilterSet.where("plan_filter_id = ? AND plan_id = ?", params[:id], params[:plan_id]).delete_all

    flash[:notice] = "Province was successfully removed!"
    redirect_to :back
  end

end
