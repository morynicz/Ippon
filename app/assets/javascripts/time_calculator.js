var groups_length = 0;
var finals_length = 0;
var players_number_per_team =1;

var teams_number = 0;
var four_team_groups = 0;
var three_team_groups = 0;
var two_team_groups =  0;

var final_fight_length =  0;
var group_fight_length =  0;

var finals_fights =  0;
var pre_finals_fights = 0;
var root="/";

$(document).on("input",".to_calculate", function () {

    read_values();

    console.log("tn: "+ teams_number);
    console.log("4tg: "+ four_team_groups);
    console.log("3tg: "+ three_team_groups);
    console.log("2tg: "+ two_team_groups);
    console.log("ffl: "+ final_fight_length);
    console.log("gfl: "+ group_fight_length);
    console.log("ff: "+ finals_fights);
    console.log("pf: "+ pre_finals_fights);
    console.log("l: "+ locations);

    groups_length = ((four_team_groups * 6 + three_team_groups * 3 + two_team_groups) * players_number_per_team * group_fight_length) / locations;
    groups_length += pre_finals_fights * players_number_per_team * final_fight_length / locations;

    if (finals_fights !== 0) {
        finals_length = ((finals_fights - 3)/((locations >1)?2:1)+ 3) * final_fight_length * players_number_per_team;
    }

    $("#finals_length").html(finals_length);
    $("#groups_length").html(groups_length);

    $("a#generate_groups").attr("href",root+"/generate/"+(four_team_groups+three_team_groups+two_team_groups)+"/"+finals_fights+"/"+pre_finals_fights+"/"+two_team_groups+"/"+three_team_groups+"/"+four_team_groups);
    console.log("r "+root);
});

function read_values(){
  teams_number = parseInt($("#teams_number").val(),10)||0;
  four_team_groups = parseInt($('#four_team_groups').val(),10) || 0;
  three_team_groups = parseInt($('#three_team_groups').val(),10) || 0;
  two_team_groups = parseInt($('#two_team_groups').val(),10) || 0;

  final_fight_length = parseInt($('#finals_time').val(),10) || 0;
  group_fight_length = parseInt($('#groups_time').val(),10) || 0;

  finals_fights = parseInt($('#finals').val(),10) || 0;
  pre_finals_fights = parseInt($('#prefinals').val(),10) || 0;

  locations = parseInt($("#locations").val(),10) || 1;
  $("a#gen_link").attr("href",root+"/generate/"+(four_team_groups+three_team_groups+two_team_groups)+"/"+finals_fights+"/"+pre_finals_fights+"/"+two_team_groups+"/"+three_team_groups+"/"+four_team_groups);
}

function generate_groups(){
  var x = new XMLHttpRequest();
  read_values();
  x.open("PATCH",root+"/generate/"+(four_team_groups+three_team_groups+two_team_groups)+"/"+finals_fights+"/"+pre_finals_fights+"/"+two_team_groups+"/"+three_team_groups+"/"+four_team_groups);
  x.send(null);
}
$(document).ready(function(){
  root =$("#hi").attr("href");
  $("#gg").click(generate_groups);
  read_values();
});
