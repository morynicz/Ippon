
var prep_participant = function(){
  $("#participant_link").attr("href", "/participations/create_new/"+$("#participant :selected").val()+"/"+$("#hi").html());
};

$(document).ready(prep_participant);
$(document).on("change","#participant",prep_participant);
