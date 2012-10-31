// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery-1.7.1.min
//= require jquery_ujs
//= require_tree .
//= require tinymce-jquery
//= require jquery.validationEngine
//= require jquery.validationEngine-en


//
//
//function test()
//{
//
//      var id = $("#1")
//      alert(id);
//        $.ajax({
//            context: this,
//            url: $(this).attr("href"),
//            type: "GET",
//            data: $(this).serialize(),
//            dataType: "json",
//            success: function(response) {
//               alert(response);
//                $(".content-holder").html(response.html);
//            }
//        });
//

    //}

$(document).ready(function() {
    $("a.group-link").click(function() {
    $.ajax({
      context: this,
      url: $(this).attr("href"),
      type: "GET",
      data: $(this).serialize(),
      dataType: "json",
      success: function(response) {
        return $(".group-result").html(response.html);
      }
    });
    return false;
  });
  $("form").validationEngine('attach');

});

//this message is for fading alert message
setTimeout("$('#flash').html(' ');",10000);