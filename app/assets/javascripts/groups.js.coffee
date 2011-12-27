# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
$(document).ready ->
  $("a.group-link").click ->
    $.ajax
      context: this
      url: $(this).attr("href")
      type: "GET"
      data: $(this).serialize()
      dataType: "json"
      success: (response) ->
        $(".groups-right").html response.html

    false


