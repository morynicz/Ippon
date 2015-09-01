
$(document).on("change","#participant",function(){
  $("#participant_link").attr("href", "/participations/create_new/"+$("#participant :selected").val()+"/"+$("#hi").html());
});
