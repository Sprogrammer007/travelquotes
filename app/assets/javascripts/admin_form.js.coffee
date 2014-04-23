ready = ->
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

$(document).ready(ready)
$(document).on('page:load', ready)

