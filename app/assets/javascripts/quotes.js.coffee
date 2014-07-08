# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->

  #tooltips
  $('.tool_tips').tooltip
    placement: 'right'
    html: true
  #email quotes
  $('.email-pop').popover
    animation: true
    html: true
    trigger: 'click'
    placement: 'bottom'
    container: 'body'

  $('.email-pop').on 'shown.bs.popover', ->
    $('.email-yes-button').click (e)->
      e.preventDefault()
      url = $(this).attr('href')
      $.post(url, {}, undefined, "script")

    $('.email-no-button').click (e)->
      e.preventDefault()
      form = $(this).attr('data-field')
      $(this).next('a').hide()
      $(this).hide().prev('p').after(form)

 
  # Details
  trip_length = parseInt($('.trip_length').text())
  current_mutiplier = undefined

  calc_rate = (a, b)->
    return parseFloat(Math.round((a * b) * 100) / 100).toFixed(2)
  
  deductibleChange = ->
    rate_element = $('.modal-body').find('#rate')
    rate = rate_element.data('rate')
    selected = $(this).find(':selected').val().split("-")
    current_mutiplier = selected[0]
    if selected[0] != "None"
      rate = rate_element.data('rate') * current_mutiplier
    rate_element.text("$#{calc_rate(rate, trip_length)}")

  $('#detail_modal').modal
    show: false
    remote: false

  $('.detail_modal').click (e)->
    e.preventDefault()
    rate = $(this).find('a').data('rate')
    drate = calc_rate(rate, trip_length)
    url = $(this).children('a').attr("href")
    $.post(url, {rate: rate} , undefined, "script").done ->
      $('.modal-body').find('#rate').text("$#{drate}")
      $('.modal-body').find('.number_dates').text("#{trip_length} Days")
      $('.modal-body').find('.deductible_select').change(deductibleChange)
      $('#detail_modal').modal('show')

  # Deductible selection change for list view
  $('.list_deduct').change ->
    selected = $(this).find(':selected').val().split("-")
    current_mutiplier = selected[0]
    rate_field = $(this).parents('.result_item_wrapper').find('.rate')
    baserate = rate_field.data('baserate')
    if selected[0] == "None"
      current_mutiplier = 1
    rate_field.find('p').text("$#{calc_rate(baserate, current_mutiplier)}")

  # Compare
  checked_product = [] 

  $('a[data-toggle="tab"]').on 'shown.bs.tab',  (e)->
    id = $(e.relatedTarget ).attr('href')
    if id != "#compare"
      $('#compare_tab').attr('data-toggle', '')
      $('#compare_tab').parent('li').addClass('disabled')
      $(id).find("input[type='checkbox']").each (i, e)->
        if $(e).is(':checked')
          $(e).prop("checked", false);
          
  $('#compare_tab').on "click", (e)->  
    url = $(this).data('url')
    e.preventDefault()
    if checked_product.length > 4
      alert "For the best comparison, please keep the number of policy below 4!"
      return false
    else if checked_product.length >= 2
      $.post(url, {products: checked_product, quote_id: $(this).data('quote-id')}, undefined, "script")
    return

  $('.compare_results').change (e)->
    name = $(this).attr("name")
    inputs = $("input[name='#{name}']")
    products = []
    inputs.each (i, e)->
      if $(e).is(':checked')
        rate = $(e).parents('.result_item_wrapper').find('.rate p').text().replace("$", "")
        products.push({rate: rate, id: parseInt($(e).val())})
    if products.length >= 2
      $('#compare_tab').attr('data-toggle', 'tab')
      $('#compare_tab').parent('li').removeClass('disabled')
    else
      $('#compare_tab').attr('data-toggle', '')
      $('#compare_tab').parent('li').addClass('disabled')
    checked_product = products
    e.preventDefault()
    return

  # Filters
  $('.remove_filter').click (e)->
    e.preventDefault()
    id = $(this).data('id')
    if $("##{id}").is(':checked')
      $("##{id}").click()
    return false

  $('.quote_filters').change (e)->
    id = $(this).attr('value') 
    url = $(this).parents('form').attr('action')
    quote_id = parseInt(url.match(/\d+\.?\d*/g))
    remove_url = "/quotes/#{quote_id}/remove_filters"

    if $(this).is(':checked')
      $.post(url, {filter_id: id}, undefined, "script")
    else
      $.post(remove_url, {filter_id: id}, undefined, "script")
    return

  # date picker
  # callback function for to min date after from is set
  setMinDateTo = (input, inst) ->
    currentFromDate = $('#quote_leave_home').val()
    if currentFromDate
      $(input).datepicker("option", "minDate", currentFromDate) 


  addDatePicker = (element) ->
    element.datepicker 
      dateFormat: "yy-mm-dd"
      altFormat: "yy/mm/dd"
      constrainInput: true
      changeYear: true
      changeMonth :true
      yearRange: "-100:+0"

    if element.selector == "#quote_return_home"
      element.datepicker("option", "beforeShow", setMinDateTo )
  
  addDatePicker $('#quote_leave_home')
  addDatePicker $('#quote_return_home')
  addDatePicker $('#quote_arrival_date')
  addDatePicker $('#quote_renew_expire_date')

  $('#quote_leave_home').change ->
    selectedFrom = $('#quote_leave_home').datepicker('getDate')
    currentTo = $('#quote_return_home').datepicker('getDate')

    if currentTo && currentTo < selectedFrom
      $('#quote_leave_home').datepicker("setDate", selectedFrom)
      $('#quote_leave_home').datepicker("option", "minDate", selectedFrom) 

  $('#quote_apply_from').change ->
    if $(this).find(':selected').text() == "Yes"
      $('.arrival_date').fadeIn()
      $('.renew').fadeIn()
      $('.renew_expire_date').fadeIn()
    else
      $('.arrival_date').fadeOut()
      $('.renew').fadeOut()
      $('.renew_expire_date').fadeOut()
      
  # new quote form js
  currentTravelTypeSelection = $('#quote_traveler_type').find(':selected').text()

  dependentHide = (hide) ->
    if hide
      $('.family_member').fadeOut()
      $('.dependent_fields').fadeOut()
    else
      $('.family_member').fadeIn()
      $('.dependent_fields').fadeIn()


  addDatePicker $('#quote_traveler_members_attributes_0_birthday')

  $('#quote_traveler_type').focus ->
    currentTravelTypeSelection = $(this).find(':selected').text()

  $('#quote_traveler_type').change ->
    type = $(this).find(':selected').text()
    adult_fields = $('.adult_fields').children()
    dependent_fields = $('.dependent_fields').children('.member_fields_group')
    if type == "Couple" && currentTravelTypeSelection == "Single"
      $('.add_adult_fields').click()
      dependentHide(true)
    else if type == "Couple" && currentTravelTypeSelection == "Family" && adult_fields.length == 1
      dependent_fields.remove()
      $('.add_adult_fields').click()
      dependentHide(true)
    else if type == "Couple" && currentTravelTypeSelection == "Family"
      dependent_fields.remove()
      dependentHide(true)
    else if type == "Single" &&  currentTravelTypeSelection == "Couple"
      $('.remove_adult_fields').click()
      dependentHide(true)
    else if type == "Single" &&  currentTravelTypeSelection == "Family" && adult_fields.length == 1
      dependent_fields.remove()
    else if type == "Single" &&  currentTravelTypeSelection == "Family"
      dependent_fields.remove()
      $('.remove_adult_fields').click()
      dependentHide(true)
      dependentHide(true)
    else if type == "Family" &&  currentTravelTypeSelection == "Couple"
      $('.add_dependent_fields').click()
      dependentHide(false)
    else if type == "Family" &&  currentTravelTypeSelection == "Single"
      $('.add_adult_fields').click()
      $('.add_dependent_fields').click()
      dependentHide(false)
    else
    currentTravelTypeSelection = type

  $('.add_adult_fields').on 'click', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    member_fields = $('.adult_fields').children()
    if member_fields.length >= 2
      alert("You Cannot Have more then 2 Adults")
    else 
      member_fields.last().after($(this).data('fields').replace(regexp, time))
      addDatePicker($("#quote_traveler_members_attributes_#{time}_birthday"))

    event.preventDefault()

  $('.remove_adult_fields').on 'click', (event) ->
    member_fields = $('.adult_fields').children()
    if member_fields.length >= 2
      member_fields.last().remove()
    else
      alert("You must have atleast 1 Adult")
    event.preventDefault()


  $('.add_dependent_fields').on 'click', (event) ->
    $(this).show()
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    member_fields = $('.dependent_fields').children('.member_fields_group')
    if member_fields.length == 0
      $('.dependent_fields').append($(this).data('fields').replace(regexp, time).replace("Adult", "Dependent"))
      addDatePicker($("#quote_traveler_members_attributes_#{time}_birthday"))
    else if member_fields.length >= 16
      alert("Cannot have more than 16 dependent")
    else
      member_fields.last().after($(this).data('fields').replace(regexp, time).replace("Adult", "Dependent"))
      addDatePicker($("#quote_traveler_members_attributes_#{time}_birthday"))
    event.preventDefault()

  $('.remove_dependent_fields').on 'click', (event) ->
    dependent_fields = $('.dependent_fields').children('.member_fields_group')
    adult_fields = $('.adult_fields').children()
    if dependent_fields.length >= 2
      dependent_fields.last().remove()
    else if dependent_fields.length == 1 && adult_fields.length == 2
      dependent_fields.last().remove()
      $('#quote_traveler_type').val("Couple")
      dependentHide(true)
    else if dependent_fields.length == 1 && adult_fields.length == 1
      dependent_fields.last().remove()
      $('#quote_traveler_type').val("Single")
      dependentHide(true)
    event.preventDefault()


$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on 'compare:accordion', ->
  $('.accordion').each (i, e) ->
    $(e).accordion
      collapsible: true,
      autoHeight: false, 
      active: false,
      icons: { "header": "icon-triangle", "activeHeader": "icon-triangle-active" }
      

