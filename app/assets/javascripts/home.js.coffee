# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $(".category").click ->
    $(this).prevAll(".category").each ->
      $(this).removeClass "selected"
      $(this).children(".sub-category-holder").hide()
      $(this).slideUp 'fast'
    $(this).addClass "selected"
    $(this).children(".sub-category-holder").show()
    $.ajax
      url: $(this).children("a").attr("href")
      type: "GET"
      data: $(this).serialize()
      dataType: "json"
      success: (response) ->
        $(this).children(".sub-category-holder").html(response.html)
    false
