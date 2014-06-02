ready = ->
<<<<<<< HEAD

=======
  $('#accordion').accordion
    collapsible: true
    
  #Age and Filter select. Since the checkbox is floated to 
  #999999 and hidden from users view, this javascript is 
  #there to cordinate clicks between the label and the checkbox.
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
  $('.age_select label, .filters_select label').on "click", (e) ->
    checkbox = $(this).prev('input[type=checkbox]')
    checkbox.prop("checked", !checkbox.prop("checked"));
    e.preventDefault()
<<<<<<< HEAD
  #Select all select none
=======

  #Select all select none options
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
  $('.select_all').click (e) ->
    $('input[type="checkbox"]').each (index, ele) ->
      if !$(ele).prop("checked")
        $(ele).prop("checked", true)
        $('.province_select').find("[data-key='" + $(ele).attr("id") + "']").addClass('selected')
      return
<<<<<<< HEAD
  #Province select helper
=======

  #Province select helper. Since we don't use label for provinces selection
  #This helper is there to check the associated checkbox for the province.
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
  $('.province_select tr.selection').on "click", (e) ->
    checkbox = "##{$(this).data("key")}"
    $(checkbox).prop("checked", !$(checkbox).prop("checked"));
    $(this).toggleClass('selected')

<<<<<<< HEAD
    #Select all select none
=======
  #Select all select none
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
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

<<<<<<< HEAD
  #Age Bracket Filter Helper
  version_select = $('select[name="q[age_sets_version_id_eq]"], select[name="q[plan_filter_sets_plan_id_eq]"]').html()
  $('select[name="q[product_id_eq]"]').change ->

    product_select = $(this).find(':selected').text()
    escaped = product_select.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(version_select).filter("optgroup[label='#{escaped}']").html()

    if options
      $('.plan_select').html(options)
    else
      $('.plan_select').html(plan_select)   
=======

>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232

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

<<<<<<< HEAD
=======
  #This is for adding new versions. All fields are generated when
  #the user visits the add version page, but for user friendly purposes
  #we toggle hide/show as the detail_type changes.
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
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

<<<<<<< HEAD

=======
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232
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

<<<<<<< HEAD

=======
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
  legal_text_sub_cat = $('#legal_text_legal_text_category_id').html()

  $('#legal_text_parent_category').change ->
    category_select = $(this).find(':selected').text()
    escaped = category_select.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(legal_text_sub_cat).filter("optgroup[label='#{escaped}']").html()

    if options
      $('#legal_text_legal_text_category_id').html(options)
    else
      $('#legal_text_legal_text_category_id').html(legal_text_sub_cat)  

  #Sorter helpers

  catEnter = (e)->
    e.stopPropagation
    overlay = " <div id='overlay'><h4>This Category Cannot Be Moved!</h4> </div>"
    if $(this).siblings().length == 0
      $(this).find('.sort_content').append(overlay)

  catLeave = (e)->
    e.stopPropagation
    $(this).find('#overlay').remove()
      
  $('.category_sort').find('li').hover(catEnter, catLeave)
  
  $('.category_sort').find('li').click (e) ->
    e.stopPropagation()
    current_active = $('.active')
    buttons = current_active.find('.sort_buttons')
    if this != current_active.get(0)
      if $(this).siblings().length != 0 
        current_active.removeClass('active')
        $(this).addClass('active')
        $(this).children('.place_holder').append(buttons)

  moveDown = (current, next, order)->
    next.find('.order').attr('value', order)
    next.attr("data-order", order)
    order++
    current.find('.order').attr('value', order)
    current.attr("data-order", order)
    next.insertBefore(current)

  moveUp = (current, prev, order)->
    prev.find('.order').attr('value', order)
    prev.attr("data-order", order)
    order--
    current.find('.order').attr('value', order)
    current.attr("data-order", order)
    prev.insertAfter(current)

  $('.sort_buttons button').click (e)->
    e.preventDefault() 
    parent = $(this).closest('li')
    content = $(this).parent().next('.sort_content')
    prev_category = parent.prev('li')
    next_category = parent.next('li')
    current_order = parseInt(parent.attr('data-order'))
    if $(this).is('.sort_up') && parent.is(':first-child')
      alert "You cannot move this category up anymore!"
    else if $(this).is('.sort_down') && parent.is(':last-child')
      alert "You cannot move this category down anymore!"
    else if $(this).is('.sort_down')
      moveDown(parent, next_category, current_order)
    else
      moveUp(parent, prev_category, current_order)
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232

$(document).ready(ready)
$(document).on('page:load', ready)

