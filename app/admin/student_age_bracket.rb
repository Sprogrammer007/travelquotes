ActiveAdmin.register StudentAgeBracket do
  menu :parent => "Super Admin"
  config.sort_order = "id_asc"
  config.action_items.delete_if { |item|
    item.display_on?(:index)
  }
  include_import


  permit_params(:student_product_id, :min_age, :max_age, :min_trip_duration, :max_trip_duration, :preex,
    student_rates_attributes: [:rate, :rate_type, :sum_insured, :effective_date])

  #Scopes
  scope :all, default: true
  scope :preex
  #Filters
  filter :student_product
  filter :student_versions, :collection => -> {StudentAgeBracket.versions_filter_selection}


  index :as => :grid  do |age|
    div class: "custom_grid_index group" do

      attributes_table_for age  do
        row "Applied Versions" do |a|
          a.student_versions.map(&:detail_type).join(" | ")
        end
        row :range
        row "Trip Duration" do |a|
          "#{a.min_trip_duration} - #{a.max_trip_duration} (Days)"
        end
        row :preex do |a|
          if a.preex
            status_tag("Yes", :ok)
          else
            status_tag("No")
          end
        end
        row :effective_date do |a|
          a.student_product.rate_effective_date.strftime("%d, %m, %Y")
        end
        row " " do |a|
          [
            link_to("View", add_future_admin_student_rate_path(id: a.id)),
            link_to("Edit", edit_admin_student_age_bracket_path(a)),
            link_to("Delete", admin_student_age_bracket_path(a), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}),
            link_to("Add Future Rate", add_future_admin_student_rate_path(id: a.student_product.id))
          ].join(" | ").html_safe
        end
        

        table_for age.student_rates.current.order("sum_insured ASC") do
          column :rate
          column :rate_type
          column :sum_insured
          column :status do |r|
            status_tag r.status, "#{r.status.downcase}"
          end
          column "" do |r|
            [
              link_to("Edit", edit_admin_student_rate_path(r)),
              link_to("Delete", admin_student_rate_path(r), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}),
            ].join(" | ").html_safe
          end
        end
        
      end
      text_node(link_to("Add Rate", new_admin_student_rate_path(id: age.id), class: "right link_button"))
    end
  end

  show do |a|
    attributes_table do
      row "Product" do |a|
          link_to a.student_product.name, admin_student_product_path(a.student_product_id)
      end
      row "Range" do |a|
        "#{a.min_age} - #{a.max_age}"
      end
      row "Trip Duration" do |a|
        "#{a.min_trip_duration} - #{a.max_trip_duration} (Days)"
      end
      row :preex do |a|
        if a.preex
          status_tag("Yes", :ok)
        else
          status_tag("No")
        end
      end
      row "Current Rate Effective Date" do |a|
        a.student_product.rate_effective_date
      end
      row "Future Rate Effective Date" do |a|
        (a.student_product.future_rate_effective_date || "No Future Rate")
      end
    end

    panel("Current Rates", class: "group") do 
      table_for a.student_rates.current do
        column :rate
        column :rate_type
        column :sum_insured
        column :status do |r|
          status_tag r.status, "#{r.status.downcase}"
        end
        column "" do |r|
          [ 
            link_to("Edit", edit_admin_student_rate_path(r)),
            link_to("Remove", admin_student_rate_path(r), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')} )
          ].join(" | ").html_safe
        end
        
      end 
      text_node link_to "Add Rate",new_admin_student_rate_path(id: a.id), class: "link_button right"
    end

    panel("Future Rates", class: "group") do 
      table_for a.student_rates.future do
        column :rate
        column :rate_type
        column :sum_insured
        column :status do |r|
          status_tag r.status, "#{r.status.downcase}"
        end
        column "" do |r|
          [ 
            link_to("Edit", edit_admin_student_rate_path(r)),
            link_to("Remove", admin_student_rate_path(r), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')} )
          ].join(" | ").html_safe
        end
        
      end 
    end

    panel("OutDated Rates", class: "group") do 
      table_for a.student_rates.outdated do
        column :rate
        column :rate_type
        column :rate_version
        column :sum_insured
        column :status do |r|
          status_tag r.status, "#{r.status.downcase}"
        end
        column "" do |r|
          [ 
            link_to("Edit", edit_admin_student_rate_path(r)),
            link_to("Remove", admin_student_rate_path(r), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')} )
          ].join(" | ").html_safe
        end
      end 
    end
  
  end

  form do |f|
    f.inputs do
      if f.object.new_record? && params[:id]
        f.input :student_product_id, :as => :hidden, :input_html => { :value => params[:id] }
        f.input :student_product_id, :as => :select, :collection => options_for_select([[params[:name], params[:id]]], params[:id]), input_html: { disabled: true, multiple: false}
      elsif f.object.new_record?
        f.input :student_product_id, :as => :hidden, :input_html => { :value => f.object.student_product_id }
        f.input :student_product, :as => :select, :collection => options_for_select(StudentProduct.all.map{ |p| [p.name, p.id]}, f.object.student_product_id), :input_html => { :class => 'tier1_select' }
      else
        f.input :student_product_id, :as => :hidden, :input_html => { :value => f.object.student_product_id }
        f.input :student_product, :as => :select, :collection => options_for_select(StudentProduct.all.map{ |p| [p.name, p.id]}, f.object.student_product_id), :input_html => { :class => 'tier1_select', disabled: true}
      end
      f.input :min_age
      f.input :max_age
      f.input :min_trip_duration
      f.input :max_trip_duration
      f.input :preex, :as => :radio, :collection => [["Yes", true], ["No", false]]
    end

    f.inputs do
      f.has_many :student_rates, :allow_destroy => true, :heading => 'Add Rates' do |cf|
        cf.input :rate
        cf.input :rate_type, :as => :select, :collection => options_for_select(StudentRate.rate_types, (cf.object.rate_type || "Daily" )) 
        cf.input :rate_version, as: :select, :collection => options_for_select(StudentRate.rate_versions, ("Primary"  || cf.object.rate_version)) 
        cf.input :sum_insured
        cf.input :status, :as => :select, :collection => options_for_select(["Current", "Future", "OutDated"], (cf.object.status || "Current"))
      end
    end

    f.actions
  end

  controller do

    def clean_params
      params.require(:student_age_bracket).permit(:min_age, :max_age, :min_trip_duration, :max_trip_duration,
        :student_rates_attributes => [:rate, :rate_type, :sum_insured, :status])
    end

    def index
      @per_page = 9
      if params[:product_id]
        @page_title = "Age Brackets for #{StudentProduct.find(params[:product_id]).name}"
      end
      super
    end

    def show
      @page_title = "Age Bracket (#{resource.range}) For #{resource.student_product.name}"
      super
    end

    def destroy
      age = StudentAgeBracket.find(params[:id])
      product = age.student_product
      age.destroy
      redirect_to admin_student_age_brackets_path(q: {student_product_id_eq: product.id})
    end

    def update
      age = StudentAgeBracket.find(params[:id])
      age.update(clean_params)
      if params[:student_age_bracket][:student_rates_attributes]
        params[:student_age_bracket][:student_rates_attributes].each_value do |attrs|
          if attrs[:_destroy] == '1'
            StudentRate.find(attrs[:id]).destroy 
          elsif attrs[:id].nil?
            age.student_rates.create!(rate: attrs[:rate], rate_type: attrs[:rate_type],
                                      sum_insured: attrs[:sum_insured], effective_date: attrs[:effective_date])
          else
            StudentRate.find(attrs[:id]).update(rate: attrs[:rate], rate_type: attrs[:rate_type],
                                      sum_insured: attrs[:sum_insured], effective_date: attrs[:effective_date])
          end
        end

      end
      redirect_to admin_student_age_brackets_path(student_product_id: params[:student_age_bracket][:student_product_id], q: {student_product_id_eq: params[:student_age_bracket][:student_product_id]})
    end
  end 
end
