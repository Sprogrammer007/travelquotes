ActiveAdmin.register StudentFilterSet do

  include_import

  menu :parent => "Super Admin",  :if => proc{ current_admin_user.email == "stevenag006@hotmail.com" }

  #Controller
  controller do         
    def create
      StudentFilterSet.where(product_id: params[:product_id]).delete_all
      if params[:filter_ids]
        ids = params[:filter_ids].map { |id| {:product_filter_id => id }}
        StudentFilterSet.create(ids) do |a|
          a.product_id = params[:product_id]
        end
        flash[:notice] = "Successfully updated filters!"
      end
      redirect_to admin_product_path(params[:product_id])
    end
  end

  #Actions
  member_action :add, method: :get do
    @page_title = "Select Filters For #{params[:name]}"
    product = Product.find(params[:id])
    @filters = ProductFilter.all.group_by(&:category)
    @already_selected_filters = product.product_filters.pluck(:id)
    render template: "admins/add_filters"
  end

  member_action :remove, method: :delete do
    ProductFilterSet.where("product_filter_id = ? AND product_id = ?", params[:id], params[:product_id]).delete_all

    flash[:notice] = "Filters was successfully removed!"
    redirect_to :back
  end

end
