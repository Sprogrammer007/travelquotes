ActiveAdmin.register StudentAgeSet do

  include_import

  menu :parent => "Super Admin"

  controller do         

    def create
      StudentAgeSet.where(student_version_id: params[:student_version_id]).delete_all
      if params[:age_ids]
        age_ids = params[:age_ids].map { |i| {:student_age_bracket_id => i }}
        StudentAgeSet.create(age_ids) do |a|
          a.version_id = params[:student_version_id]
        end
        flash[:notice] = "Successfully updated age brackets!"
      end
      redirect_to admin_student_version_path(params[:student_version_id])
    end
  end

  #Actions
  member_action :add, method: :get do
    @page_title = "Select Age Brackets"
    @version = StudentVersion.find(params[:id])
    @ages = StudentAgeBracket.where(:student_product_id => @version.student_product_id)
    @already_selected_ages = @ages.pluck(:id) & @version.student_age_brackets.pluck(:id)
    render template: "admins/add_student_age"
  end
end
