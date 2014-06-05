ActiveAdmin.register Deductible do
	config.sort_order = "id_asc"
	include_import
	preserve_default_filters!

	menu :parent => "Super Admin"

  permit_params :product_id, :amount, :mutiplier, :condition, :age
  
  index do
    selectable_column
    column "Deductible Amount", :amount
    column "Deductible Mutiplier", :mutiplier
    column "Condition For Age", :condition
    column "Age of Condition", :age
    actions defaults: true, dropdown: true
  end

 #Show
  show :title => proc{ "Deductibles For " + resource.product.name } do |v|
    attributes_table do
      row "Product" do |d|
        link_to d.product.name, admin_product_path(d.product_id)
      end
      row "Deductible Amount" do |d|
        d.amount
      end
      row "Deductible Mutiplier" do |d|
        d.mutiplier
      end
      row "Condition For Age"do |d|
        case d.condition
        when "gt"
          "Greater"
        when "lt"
          "Lesser"
        when "gteq"
          "Greater and Equal"
        when "lteq" 
          "Lesser and Equal"
        else
          "Not Applicable"
        end
      end
      row "Age of Condition"do |d|
        d.age
      end
    end
  end 

  #Form
  form do |f|
    f.inputs do
      if f.object.new_record? && params[:id]
        f.input :product_id, :as => :hidden, input_html: { value: params[:id] }
        f.input :product, :as => :select, :collection => options_for_select([[params[:name], params[:id]]], params[:id]), 
        input_html: { disabled: true}
      else 
        f.input :product
      end
      f.input :amount, :label => "Deductible Amount"
      f.input :mutiplier, :label => "Deductible Mutiplier"
      f.input :condition, :label => "Select Condition for Age" , :as => :select, :collection =>  options_for_select(Deductible.conditions_options, (f.object.condition || "Not Applicable"))
      f.input :age, :label => "The Age that the Condition Applies to"
    end
    f.actions
  end

  controller do
    def clean_params
      params.require(:age_bracket).permit(:min_age, :max_age, :min_trip_duration, :max_trip_duration)
    end

    def clean_rate_params
      params.require(:age_bracket).permit(:rates_attributes => [:rate, :rate_type, :sum_insured, :effective_date])
    end

    def update
      age = AgeBracket.find(params[:id])
      age.update(clean_params)
      if params[:age_bracket][:rates_attributes]
        params[:age_bracket][:rates_attributes].each_value do |attrs|
          Rate.find(attrs[:id]).update(rate: attrs[:rate], rate_type: attrs[:rate_type],
                                      sum_insured: attrs[:sum_insured], effective_date: attrs[:effective_date])
        end
      end
      redirect_to admin_age_bracket_path(age)
    end
  end 
end
