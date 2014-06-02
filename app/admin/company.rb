ActiveAdmin.register Company do
	config.sort_order = "id_asc"
	include_import
	menu :priority => 1
	permit_params :name, :short_hand, :logo, :status

	#Scopes
	scope :all, default: true
	scope :active

	#Filters
	preserve_default_filters!
	remove_filter :regions
	remove_filter :logo
	remove_filter :status
	remove_filter :products

	index do
		selectable_column
		column :name
		column :short_hand
		column :logo do |c|
			image_tag c.logo, height: "60%"
		end
		column :status do |c|
			if c.status
				status_tag("Active", :ok)
			else
				status_tag("Not Active")
			end
		end
<<<<<<< HEAD
		actions :defaults => true
	end
=======
		actions defaults: true, dropdown: true do |c|
			item  "Add Visitor Policy", new_admin_product_path(id: c.id)
			item  "Add Student Policy", "#"
			item  "Add Regions", add_admin_region_path(id: c.id)
		end
	end
	
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
	#Form
	form do |f|
		f.inputs do
			f.input :name
			f.input :short_hand
			f.input :logo
<<<<<<< HEAD
			f.input :status, :as => :radio, :collection => [['Active', 'true'], ['Not', 'false']]
		end
=======
			f.input :status, :as => :radio, :collection => [['Active', true], ['Not', false]]
		end

>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
		f.actions
	end

	#Show
	show do |c|
		div class: "show_left" do
<<<<<<< HEAD
			c.show_table(self)
=======
			attributes_table do
	      row :short_hand
	      row :logo do
	        image_tag(c.logo)
	      end
	      row :status do |c|
					if c.status
						status_tag("Active", :ok)
					else
						status_tag("Not Active")
					end
				end
    	end
    	
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
			panel("products", class: 'group single_show') do
				if c.products.any?
					ul do
						c.products.each do |p|
							li do
								attributes_table_for p do
									row :name do |p|
										link_to "#{p.name}", admin_product_path(p)
									end
<<<<<<< HEAD
					        row :product_number
=======
					        row :policy_number
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
					        row :description do |p|
					        	div class: 'des_flown' do
					        		text_node p.description.html_safe
					        	end

					        end
					        row :status do |p|
										if p.status
											status_tag("Active", :ok)
										else
											status_tag("Not Active")
										end
									end
<<<<<<< HEAD
									text_node link_to "Edit", edit_admin_product_path(p), class: "link_button right"
									text_node link_to "View", edit_admin_product_path(p), class: "link_button right"
=======
									text_node link_to "Delete", admin_product_path(p), class: "link_button right", method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}
									text_node link_to "Edit", edit_admin_product_path(p), class: "link_button right"
									text_node link_to "View", admin_product_path(p), class: "link_button right"
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
					      end
					    end
						end
					end
				else
					div class: "no_list" do 
						text_node "<span>No Products Were Found For This Company, Create One!</span>".html_safe
					end
				end
				text_node button_to "Add Product", new_admin_product_path(), method: 'get', class: "right"
			end
		end

		div class: "show_right" do
			panel("Regions of Operations", class: 'group') do
				table_for c.provinces do
					column "" do |p|
						image_tag p.flag, size: "35x35"
					end
					column :name
					column :short_hand
					column "" do  |p|
						link_to "Remove Region", remove_admin_region_path(id: p.id, company_id: c.id), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}
					end
				end

				text_node link_to "Add/Remove Regions", add_admin_region_path(id: c.id), class: "link_button right"
			end if c.provinces
		end
	end

end
