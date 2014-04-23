ActiveAdmin.register ProductFilter do
	config.sort_order = "id_asc"
	include_import
	preserve_default_filters!
 
	menu :parent => "Companies"

	#Scopes
	scope :all, default: true
	scope :non_medical_benefits
	scope :medical_benefits
	
	index do
		selectable_column
		column :name
		column :category
		column "Description" do |p|
    	p.description.html_safe
    end
		default_actions
	end


	form do |f|
		f.inputs do
			f.input :product,	:input_html => { :class => 'tier1_select' }
			f.input :name
			f.input :description, :as => :ckeditor
			
			# f.input :plans,		:as => :select,	:input_html => { :class => 'tier2_select' },
			# 				:collection => grouped_options_for_select(Hash[Product.all.map {|pro|
			# 											[ pro.name, pro.plans.map {|p| [p.type, p.id]} ]}], 
			# 											age_bracket.plans.map { |p| p.id })
		end
		f.actions
	end
end
