# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $(".category").hover (->
    $(this).addClass "selected"
    $(this).children(".gray-holder").show()
    $.ajax
      url: $(this).children("a").attr("href")
      type: "GET"
      data: $(this).serialize()
      dataType: "json"
      success: (response) ->
        $(this).children(".gray-holder").html(response.html)
  ), ->
    $(this).children(".gray-holder").hide()
    $(this).removeClass "selected"

  $(".category").click ->
    false
