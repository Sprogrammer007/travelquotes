ready = ->

  #Age and Filter select. Since the checkbox is floated to 
  #999999 and hidden from users view, this javascript is 
  #there to cordinate clicks between the label and the checkbox.
  $('.age_select label, .filters_select label').on "click", (e) ->
    checkbox = $(this).prev('input[type=checkbox]')
    checkbox.prop("checked", !checkbox.prop("checked"));
    e.preventDefault()

  #Select all select none options
  $('.select_all').click (e) ->
    $('input[type="checkbox"]').each (index, ele) ->
      if !$(ele).prop("checked")
        $(ele).prop("checked", true)
        $('.province_select').find("[data-key='" + $(ele).attr("id") + "']").addClass('selected')
      return

  #Province select helper. Since we don't use label for provinces selection
  #This helper is there to check the associated checkbox for the province.
  $('.province_select tr.selection').on "click", (e) ->
    checkbox = "##{$(this).data("key")}"
    $(checkbox).prop("checked", !$(checkbox).prop("checked"));
    $(this).toggleClass('selected')

  #Select all select none
  $('.select_all').click (e) ->
    $('input[type="checkbox"]').each (index, ele) ->
      if !$(ele).prop("checked")
        $(ele).prop("checked", true)
        $('.province_select').find("[data-key='" + $(ele).attr("id") + "']").addClass('selected')
      return

  $('.select_none').click (e) ->
    $('input[type="checkbox"]').each (index, ele) ->
      if $(ele).prop("checked")
        $(ele).prop("checked", false)
        $('.province_select').find("[data-key='" + $(ele).attr("id") + "']").removeClass('selected')
      return


  tier2select = $('.tier2_select').html()

  $('.tier1_select').change ->
    tier1select = $(this).find(':selected').text()
    escaped = tier1select.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(tier2select).filter("optgroup[label='#{escaped}']").html()

    if options
      $('.tier2_select').html(options)
    else
      $('.tier2_select').html(tier2select)   



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

  #This is for adding new versions. All fields are generated when
  #the user visits the add version page, but for user friendly purposes
  #we toggle hide/show as the detail_type changes.
  $('.detail_type').change ->
    single = $('.single_details')
    couple = $('.couple_details')
    family = $('.family_details')
    type = $(this).find(':selected').text()
    switch type
      when 'Couple'
        couple.show()
        family.hide()
        single.hide()
      when 'Family'
        family.show()
        couple.hide()
        single.hide()
      else
        single.show()
        couple.hide()
        family.hide()

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

  #Age Bracket Filter Helper
  version_select = $('select[name="q[age_sets_version_id_eq]"], select[name="q[plan_filter_sets_plan_id_eq]"]').html()
  
  $('select[name="q[product_id_eq]"]').change ->
    product_select = $(this).find(':selected').text()
    escaped = product_select.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(version_select).filter("optgroup[label='#{escaped}']").html()

    if options
      $('.plan_select').html(options)
    else
      $('.plan_select').html(version_select)

  #Helper for new legal text category selection, works just like the
  #Age Bracket Filter helper
  legal_text_sub_cat = $('#legal_text_policy_sub_category').html()

  $('#legal_text_policy_category').change ->
    category_select = $(this).find(':selected').text()
    escaped = category_select.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(legal_text_sub_cat).filter("optgroup[label='#{escaped}']").html()

    if options
      $('#legal_text_policy_sub_category').html(options)
    else
      $('#legal_text_policy_sub_category').html(legal_text_sub_cat)  

$(document).ready(ready)
$(document).on('page:load', ready)

