ActiveAdmin.register StudentFilter do
  config.sort_order = "id_asc"
  config.paginate = false
  # config.filters = false
  include_import

  permit_params :category, :name, :associated_lt_id, :descriptions, :sort_order

  #Scopes
  scope :all, default: true

  #Filters
  filter :category
  filter :name


  menu :parent => "Global Settings", :label => "Global Student Filters"

  index :title => "Global Student Filters" do
    selectable_column
    column :name
    column :category
    column"Associated LegalText Category" do |pf|
      pf.student_lg_cat.name() if pf.student_lg_cat()
     end
    column :descriptions do |p|
      p.descriptions.html_safe() if p.descriptions
    end
    actions defaults: true, dropdown: true
  end
  
  show do |pf|
     attributes_table do
      row :name
      row :category
      row "Associated LegalText Category" do |pf|
        pf.student_lg_cat.name() if pf.student_lg_cat()
      end
      row :descriptions do |pf|
        pf.descriptions.html_safe() if pf.descriptions()
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :sort_order
      f.input :category, :as => :select, :collection => options_for_select(StudentFilter.filter_categories.map(&:upcase), f.object.category)
      f.input :associated_lt_id, :lebal => "Associated LegalText Category", :as => :select, :collection => options_for_select(StudentLgCat.all.map { |l| [l.name, l.id] })
      f.input :descriptions, input_html: { class: "tinymce" }
    end
    f.actions
  end
end
