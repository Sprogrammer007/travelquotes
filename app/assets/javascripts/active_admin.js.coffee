#= require active_admin/base
#= require editable_text_column
#= require admin_form
#= require jquery.ui.accordion
#= require tinymce

$(document).ready ->
  tinyMCE.init
    mode: "textareas"
    theme: 'advanced'
    fontsize_formats: "8pt 9pt 10pt 11pt 12pt 26pt 36pt"
    editor_selector: "tinymce"
    toolbar: "sizeselect | bold italic | fontselect |  fontsizeselect"
    plugins : 'advlist, autolink, lists, print, preview'
  return
