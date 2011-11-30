# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $(".tab_link").click ->
    $(".tab-holder").each ->
      $(this).removeClass "active"
    $(this).parents(".tab-holder").addClass 'active'
    $.ajax
      url: $(this).attr("href")
      type: "GET"
      data: $(this).serialize()
      dataType: "json"
      success: (response) ->
        $(".job-holder").html(response.html)
    false

  $("#find_job_button").click ->
    $.post $("form#search-form").attr("action"), $("form#search-form").serialize(), ((response) ->
      $(".content-left-holder").html response.html
    ), "json"
    false

  $("#rg_find_job_button").click ->
    $.post $("form#rg-search-form").attr("action"), $("form#rg-search-form").serialize(), ((response) ->
      $(".content-holder").html response.html
    ), "json"
    false

  $("#user_name").blur ->
    unless $(this).val().match(/^\s*$/)
      $.ajax
        url: "/search/check_user_name?name="+$(this).val()
        type: "GET"
        data: $(this).serialize()
        dataType: "json"
        success: (response) ->
          if response.success == true
            $("#check_user_name").html("<img src='/assets/active-arrow.png' alt='Active-arrow'><p>Avalable !!</p>")
          else
            $("#check_user_name").html("<img src='/assets/deactive-arrow.png' alt='Active-arrow'><p>Not Avalable !!</p>")

   
    