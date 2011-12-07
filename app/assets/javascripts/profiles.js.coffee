# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
   $("#update_profile_button").click ->
    $.post $("form#create_profile_form").attr("action"), $("form#create_profile_form").serialize(), ((response) ->
      $(".content-holder").html response.html
    ), "json"
    false
