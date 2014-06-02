module ActiveAdmin
  module Views
    class IndexAsTable < ActiveAdmin::Component
<<<<<<< HEAD
=======

>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
      def editable_text_column resource, attr
        val = resource.send(attr)
        val = "&nbsp;" if val.blank?
 
        html = %{
                  <div  id='editable_text_column_#{resource.id}' 
                        class='editable_text_column' >
                        #{val}
                   </div>
 
                   <input 
 
                      data-path='#{resource.class.name.tableize}' 
                      data-attr='#{attr}' 
                      data-resource-id='#{resource.id}' 
                      class='editable_text_column admin-editable' 
                      id='editable_text_column_#{resource.id}' 
 
                      style='display:none;' />
              }
        html.html_safe
      end
<<<<<<< HEAD
=======

>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
    end
  end
end