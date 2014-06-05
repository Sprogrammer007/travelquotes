#= require active_admin/base
#= require editable_text_column
#= require admin_form
#= require jquery.ui.accordion
#= require tinymce-jquery

$(document).ready ->
  tinyMCE.init
    mode: "textareas"
    theme: 'modern'
    editor_selector: "tinymce"
    plugins : 'advlist autolink link image lists charmap print preview'
  return
