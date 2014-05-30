ready =  ->
  admin = new admins()
  admin.init()
  $('.editable_text_column').on "dblclick", (e) ->
    admin.editable_text_column_do(this)
    return
class admins
  init: ->
    this.set_admin_editable_events()
    return

  set_admin_editable_events: ->
    $(".admin-editable").on "keypress", (e) ->
      $(e.currentTarget).hide()  if e.keyCode is 27
      if e.keyCode is 13
        path = $(e.currentTarget).attr("data-path")
        attr = $(e.currentTarget).attr("data-attr")
        resource_id = $(e.currentTarget).attr("data-resource-id")
        val = $(e.currentTarget).val()
        val = $.trim(val)
        val = "&nbsp;"  if val.length is 0
        $("div#" + $(e.currentTarget).attr("id")).html val
        $(e.currentTarget).hide()
        payload = {}
        resource_class = path.slice(0, -1) # e.g. path = meters, resource_class = meter
        payload[resource_class] = {}
        payload[resource_class][attr] = val
        $.put("/admin/" + path + "/" + resource_id, payload).done (result) ->
          console.log result
          return

    return

    $(".admin-editable").on "blur", (e) ->
      $(e.currentTarget).hide()
      return

    return

  editable_text_column_do: (el) ->
    input = "input#" + $(el).attr("id")
    $(input).width($(el).width() + 4).height $(el).height() + 4
    $(input).css
      top: ($(el).offset().top - 2)
      left: ($(el).offset().left - 2)
      position: "absolute"

    val = $.trim($(el).html())
    val = ""  if val is "&nbsp;"
    $(input).val val
    $(input).show()
    $(input).focus()
    return
 
                  
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)