# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("a.category-link").click ->
    $(this).parent(".category").prevAll(".category").each ->
      $(this).removeClass "selected"
      $(this).children(".sub-category-holder").hide()
      $(this).slideUp "fast"

    $(this).parent(".category").addClass "selected"
    $(this).next(".sub-category-holder").show()
    $.ajax
      context: this
      url: $(this).attr("href")
      type: "GET"
      data: $(this).serialize()
      dataType: "json"
      success: (response) ->
        $(this).next(".sub-category-holder").html response.html
    false

  $("#register-button").click ->
    $("form#sign-up-form").submit()