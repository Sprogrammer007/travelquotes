ActiveAdmin.register AgeSet do

	include_import

	menu :parent => "Super Admin", :if => proc{ current_admin_user.email == "stevenag006@hotmail.com" }

  controller do         
    def permitted_params             
      params.permit!        
    end     

    def destroy
    end

    def create
      AgeSet.where(plan_id: params[:plan_id]).delete_all
      if params[:age_ids]
        age_ids = params[:age_ids].map { |i| {:age_bracket_id => i }}
        AgeSet.create(age_ids) do |a|
          a.plan_id = params[:plan_id]
        end
        flash[:notice] = "Successfully updated age brackets!"
      end
      redirect_to admin_plan_path(params[:plan_id])
    end
  end

  #Actions
  member_action :add, method: :get do
    @page_title = "Select Age Brackets"
    @plan = Plan.find(params[:id])
    @ages = AgeBracket.where(:product_id => @plan.product_id)
    @already_selected_ages = @ages.pluck(:id) & @plan.age_brackets.pluck(:id)
    render template: "admins/add_age"
  end
end
