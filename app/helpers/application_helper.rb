module ApplicationHelper

  def link_to_add_fields(name, association, object)
    form = render("admins/#{association.to_s}" + "_form", o: object)

    link_to(name, '#', class: "add_fields", data: {fields: form.gsub("\n", "")})
  end

  def link_to_add_new_fields(name, f, association, *args)
    options = *args
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder )
    end
    link_to(name, '#', class: "#{name.split(" ").join("_").downcase.gsub("+", "add")}_fields btn btn-info right", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def display?(obj)
    obj ? "" : "style='display: none;'".html_safe 
  end
end
