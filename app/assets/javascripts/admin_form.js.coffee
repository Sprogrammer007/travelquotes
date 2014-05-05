ready = ->

  $('.age_select label, .filters_select label').on "click", (e) ->
    console.log("clicked")
    checkbox = $(this).prev('input[type=checkbox]')
    checkbox.prop("checked", !checkbox.prop("checked"));
    e.preventDefault()


  $('.province_select tr.selection').on "click", (e) ->
    checkbox = "##{$(this).data("key")}"
    $(checkbox).prop("checked", !$(checkbox).prop("checked"));
    $(this).toggleClass('selected')


  tier2select = $('.tier2_select').html()

  $('.tier1_select').change ->
    tier1select = $(this).find(':selected').text()
    escaped = tier1select.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(tier2select).filter("optgroup[label='#{escaped}']").html()

    if options
      $('.tier2_select').html(options)
    else
      $('.tier2_select').html(tier2select)   

  #Age Bracket Filter Helper
  plan_select = $('select[name="q[age_sets_plan_id_eq]"], select[name="q[plan_filter_sets_plan_id_eq]"]').html()
  $('select[name="q[product_id_eq]"]').change ->

    product_select = $(this).find(':selected').text()
    escaped = product_select.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(plan_select).filter("optgroup[label='#{escaped}']").html()

    if options
      $('.plan_select').html(options)
    else
      $('.plan_select').html(plan_select)   

  #New and Existing
  $('.new_selection').hide()
  $('input:radio[value="Yes"]').prop("checked", true)
  $('input:radio[name="province[from_existing]"]').change ->
    checked = $(this).val()

    if checked == "Yes"
      $('.existing_selection').toggle()
      $('.new_selection').hide()
    else
      $('.existing_selection').hide()
      $('.new_selection').toggle()

  $('.detail_type').change ->
    type = $(this).find(':selected').text()

    if type == 'Family'
      $('.family_details').toggle()
    else
      $('.family_details').hide()

  #Toggle Show More/Less
  (($) ->
    $.fn.OverFlown = ->
      _elm = $(this)[0]
      _hasScrollBar = false
      _hasScrollBar = true  if (_elm.clientHeight < _elm.scrollHeight) or (_elm.clientWidth < _elm.scrollWidth)
      _hasScrollBar

    $('.des_flown').each (index) -> 
    
      if $(this).OverFlown()
        $(this).addClass("show_less more_info")
  ) jQuery
 
  $('.row-description .more_info').on("mouseenter", ->
    $(this).removeClass('show_less').addClass("show_more")).on("mouseleave", ->
    $(this).removeClass('show_more').addClass("show_less"))

  removeFields = (e) ->
    $(this).parents('.rate_fields').replaceWith($(this).data('addfields'))
    $('.add_fields').on 'click', addFileds
    e.preventDefault()
    return false

  addFileds = (e) ->
    parent = $(this).parent()
    addfields = parent.html().replace(/\s+/g, " ").replace("\n", "")
    $(this).replaceWith( $(this).data('fields'))
    $('.remove_fields').on('click', removeFields).attr('data-addfields', addfields)
    $(parent.find('input[name="future[][effective_date]"]')).datepicker
      dateFormat: "yy-mm-dd"
      altFormat: "yy/mm/dd"
      constrainInput: true
      changeYear: true
      changeMonth: true
      minDate: 1 #set min date to current date
    e.preventDefault()

  $('.add_fields').on 'click', addFileds



$(document).ready(ready)
$(document).on('page:load', ready)

