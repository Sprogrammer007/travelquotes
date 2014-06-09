ActiveAdmin.register AgeSet do

	include_import

	menu :parent => "Super Admin"

  controller do         

    def create
      AgeSet.where(version_id: params[:version_id]).delete_all
      if params[:age_ids]
        age_ids = params[:age_ids].map { |i| {:age_bracket_id => i }}
        AgeSet.create(age_ids) do |a|
          a.version_id = params[:version_id]
        end
        flash[:notice] = "Successfully updated age brackets!"
      end
      redirect_to admin_version_path(params[:version_id])
    end
  end

  #Actions
  member_action :add, method: :get do
    @page_title = "Select Age Brackets"
    @version = Version.find(params[:id])
    @ages = AgeBracket.where(:product_id => @version.product_id)
    @already_selected_ages = @ages.pluck(:id) & @version.age_brackets.pluck(:id)
    render template: "admins/add_age"
  end
end
