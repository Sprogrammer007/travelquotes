ActiveAdmin.register Deductible do
	config.sort_order = "id_asc"
	include_import
	preserve_default_filters!

	menu :parent => "Companies"

  permit_params :product_id, :amount, :mutiplier, :condition, :age
  
  index do
    selectable_column
    column :amount
    column :mutiplier
    column :condition
    column :age
    actions defaults: true, dropdown: true
  end

  #Form
  form do |f|
    f.inputs do
      if params[:id]
        f.input :product_id, :as => :hidden, input_html: { value: params[:id] }
        f.input :product, :as => :select, :collection => options_for_select([[params[:name], params[:id]]], params[:id]), 
        input_html: { disabled: true}
      else 
        f.input :product
      end
      f.input :amount
      f.input :mutiplier
      f.input :condition, :as => :select, :collection =>  options_for_select(Deductible.conditions_options)
      f.input :age
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
