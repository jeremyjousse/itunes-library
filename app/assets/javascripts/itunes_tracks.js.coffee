# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
 $(".select").each (i, e) ->
  select = $(e)
  options = {}
  options.dropdownCssClass = "bigdrop"
  select.select2 options
 $('#rating').raty
  width: 150 
  score: ($('#rating').attr("data-rating")/20) 
  click: (score, evt) -> click: $.post $('#rating').attr("data-post-url"),
   rating: (score*20)
   (data) -> nul
   #(data) -> alert("Successfully rated")
  cancel: true
 $('.static_rating').raty
  width: 150
  score: -> ($(this).attr("data-rating")/20)
  readOnly: true


$(document).ready(ready)
$(document).on('page:load', ready)