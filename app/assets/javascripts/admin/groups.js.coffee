# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# remove_job = (jobid, gid) ->
#  id = jobid
#  gid = gid
#  $.ajax
#    url: "/admin/groups/remove_job?group_id=" + gid + "&job_id=" + jobid
#    type: "get"
#    processData: false
#    data: $(this).serialize()
#    dataType: "html"
#    success: (data) ->
#      $(".delete_result").html data.html
#
#  false