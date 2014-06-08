#= require active_admin/base
#= require editable_text_column
#= require admin_form
#= require jquery.ui.accordion
#= require tiny_mce/tiny_mce

$(document).ready ->
  tinyMCE.init
    mode: "textareas"
    theme: 'advanced'
    editor_selector: "tinymce"
    plugins : 'advlist, autolink, lists, print, preview'
  return
