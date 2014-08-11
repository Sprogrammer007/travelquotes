ActiveAdmin.register StudentRate do
  config.sort_order = "id_asc"
  config.action_items.delete_if { |item|
    item.display_on?(:index)
  }
  include_import

  permit_params :rate, :rate_type, :student_age_bracket_id, :sum_insured, :effective_date

  #Scopes
  scope :all, default: true

  #Filters
  filter :age_bracket, :collection => proc { StudentRate.select_age_bracket_options }  
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

  show :title => proc{ "Rate for " + resource.student_age_bracket.student_product.name + "(#{resource.student_age_bracket.range})" } do |r|
    attributes_table do
      row "Product" do |r|
        r.student_age_bracket.student_product.name
      end
      row "Age Bracket" do |r|
        r.student_age_bracket.range
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
        f.input :student_age_bracket_id, :as => :hidden, input_html: { value: params[:id] }
        f.input :student_age_bracket, as: :select, :collection => grouped_options_for_select(StudentRate.select_age_bracket_options, params[:id]), 
        input_html: { disabled: true} 
      else 
        f.input :student_age_bracket, as: :select, :collection => grouped_options_for_select(StudentRate.select_age_bracket_options, f.object.student_age_bracket_id) 
      end
      f.input :rate
      f.input :rate_type, as: :select, :collection => options_for_select(StudentRate.rate_types, f.object.rate_type) 
      f.input :sum_insured
    end
    f.actions
  end

  controller do         
    def clean_params             
      params.permit(:commit, :effective_date, :future => [:student_age_bracket_id, :rate_type, :sum_insured, :rate, :effective_date])     
    end

    def new
      if params[:id]
        @age = StudentAgeBracket.find(params[:id])
        @page_title = "New Rate For #{@age.student_product.name}"
      end
      super
    end

    def edit 
      @page_title = "Edit Rate For #{resource.student_age_bracket.student_product.name}(#{resource.student_age_bracket.range})"
    end     

    def destroy
      super do |format|
        redirect_to :back and return
      end
    end
  end
  
  #Actions
  member_action :add_future, method: :get do
    @product = StudentProduct.find(params[:id])
    @ages = @product.student_age_brackets
    @page_title = "Add Future Rates For #{@product.name}"
    render template: "admins/add_student_rate"
  end

  collection_action :create_future, method: :post do
    effective_date = clean_params[:effective_date]
    product = StudentProduct.find(params[:product_id])
    if effective_date.empty?
      flash[:error] = "Future effective date cannot be blank"
    else
      product.update(:future_rate_effective_date => effective_date)
      StudentRate.create(clean_params[:future]) do |r|
        r.effective_date = effective_date
        r.status = "Future"
      end
    end
    redirect_to admin_student_product_path(product)
  end

  collection_action :update_effective_date, method: :post do
    product = StudentProduct.find(params[:product_id])
    rate_ids = []
    new_effective_date = (params[:current_effective_date] || params[:future_effective_date])
    if new_effective_date.blank?
      flash[:error] = "Please provide a new effective date!"
    else 
      if params[:current_effective_date]
        product.update(rate_effective_date: new_effective_date)
        product.student_age_brackets.each do |age|
          rate_ids << age.student_rates.current.pluck(:id)
        end
        StudentRate.where(id: rate_ids.flatten).update_all({effective_date: new_effective_date})
      else
        product.student_age_brackets.each do |age|
          product.update(future_rate_effective_date: new_effective_date)
          rate_ids << age.student_rates.future.pluck(:id)
        end
        StudentRate.where(id: rate_ids.flatten).update_all({effective_date: new_effective_date})
      end
    end
    redirect_to :back
  end


end
