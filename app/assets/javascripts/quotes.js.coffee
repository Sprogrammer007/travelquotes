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

  $('#quote_leave_home').change ->
    selectedFrom = $('#quote_leave_home').datepicker('getDate')
    currentTo = $('#quote_return_home').datepicker('getDate')

    if currentTo && currentTo < selectedFrom
      $('#quote_leave_home').datepicker("setDate", selectedFrom)
      $('#quote_leave_home').datepicker("option", "minDate", selectedFrom) 

  $('#quote_return_home').datepicker
    dateFormat: "yy-mm-dd"
    altFormat: "yy/mm/dd"
    constrainInput: true
    beforeShow: setMinDateTo
    maxDate: "+2y"

$(document).ready(ready)
$(document).on('page:load', ready)

