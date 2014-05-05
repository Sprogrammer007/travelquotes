# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->

  # callback function for to min date after from is set
  setMinDateTo = (input, inst) ->
    currentFromDate = $('#quote_leave_home').val()
    if currentFromDate
      $(input).datepicker("option", "minDate", currentFromDate) 

  $('#quote_leave_home').datepicker 
    dateFormat: "yy-mm-dd"
    altFormat: "yy/mm/dd"
    constrainInput: true
    changeYear: true

  $('#quote_return_home').datepicker 
    dateFormat: "yy-mm-dd"
    altFormat: "yy/mm/dd"
    constrainInput: true
    changeYear: true

  $('#quote_leave_home').change ->
    selectedFrom = $('#quote_leave_home').datepicker('getDate')
    currentTo = $('#quote_return_home').datepicker('getDate')

    if currentTo && currentTo < selectedFrom
      $('#quote_leave_home').datepicker("setDate", selectedFrom)
      $('#quote_leave_home').datepicker("option", "minDate", selectedFrom) 
  
  $('#quote_arrival_date').datepicker 
    dateFormat: "yy-mm-dd"
    altFormat: "yy/mm/dd"
    constrainInput: true
    changeYear: true

  $('#quote_apply_from').change ->
    if $(this).find(':selected').text() == "Yes"
      $('.arrival_date').fadeIn()
    else
      $('.arrival_date').fadeOut()

  currentTravelTypeSelection = $('#quote_traveler_type').find(':selected').text()

  dependentHide = (hide) ->
    if hide
      $('.dependent_fields').fadeOut()
      $('.family_member').fadeOut()
    else
      $('.dependent_fields').fadeIn()
      $('.family_member').fadeIn()

  addDatePicker = (element) ->
    element.datepicker 
      dateFormat: "yy-mm-dd"
      altFormat: "yy/mm/dd"
      constrainInput: true
      changeYear: true

  $('#quote_traveler_members_attributes_0_birthday').datepicker 
    dateFormat: "yy-mm-dd"
    altFormat: "yy/mm/dd"
    constrainInput: true
    changeYear: true
    
  $('#quote_traveler_type').focus ->
    currentTravelTypeSelection = $(this).find(':selected').text()

  $('#quote_traveler_type').change ->
    type = $(this).find(':selected').text()
    adult_fields = $('.adult_fields').children()
    if type == "Couple" && currentTravelTypeSelection == "Single"
      $('.add_adult_fields').click()
      dependentHide(true)
    else if type == "Couple" && currentTravelTypeSelection == "Family" && adult_fields.length == 1
      $('.dependent_fields').empty()
      $('.add_adult_fields').click()
      dependentHide(true)
    else if type == "Couple" && currentTravelTypeSelection == "Family"
      $('.dependent_fields').empty()
      dependentHide(true)
    else if type == "Single" &&  currentTravelTypeSelection == "Couple"
      $('.remove_adult_fields').click()
      dependentHide(true)
    else if type == "Single" &&  currentTravelTypeSelection == "Family"
      $('.dependent_fields').empty()
      $('.remove_adult_fields').click()
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

