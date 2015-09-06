var g_teams_number = 0;
var g_finals_fights = 0;
var  g_pre_finals_fights = 0;
var  g_four_team_groups = 0;
var  g_three_team_groups = 0;
var  g_two_team_groups = 0;

$(document).on("input",".to_calculate", function () {
  g_read_values();

  var alg_table= [[1,0,1,0],[2,0,2,1],[4,1,0,0],[8,2,4,3],[16,4,8,7],[24,6,12,11],[32,8,16,15],[48,12,24,23],[64,16,32,31],[96,24,48,37],[128,32,64,63],[192,48,96,81]];

  var i=0;
  var ni = 0;
  var gi = 1;
  var fi = 2;
  var ffi = 3;

  while ((i < alg_table.length) && ( teams_number > alg_table[i][ni])) {
    i+= 1;
  }

  g_groups = alg_table[i][gi];
  finalists = alg_table[i][fi];
  final_fight_no = alg_table[i][ffi];

  g_finals_fights = (alg_table[i][ffi] > 7 ) ? 7 : alg_table[i][ffi];
  g_pre_finals_fights = (alg_table[i][ffi] > 7 ) ? alg_table[i][ffi] - 7 : 0;

  garr = [];
  for(var i=0; i< g_groups; ++i) {
    garr.push(0);
  }

  for(var i=0; i< teams_number; ++i) {
    garr[i % g_groups] += 1;
    console.log("i: "+ i + " garr: " + garr);
  }

  cnt_arr = [0,0,0,0,0];

  for ( var i=0; i< garr.length; ++i) {
    cnt_arr[garr[i]]++;
    console.log("i: "+ i + " cnt_arr: " + cnt_arr);
  }

  g_four_team_groups = cnt_arr[4];
  g_three_team_groups = cnt_arr[3];
  g_two_team_groups = cnt_arr[2];

  var g_number_of_fights = g_four_team_groups * 6 + g_three_team_groups * 3 + g_two_team_groups;

$("#calculated_four_team_groups").html(g_four_team_groups);
$("#calculated_three_team_groups").html(g_three_team_groups);
$("#calculated_two_team_groups").html(g_two_team_groups);
$("#calculated_groups").html(g_groups);

$("#calculated_number_of_fights").html(g_number_of_fights);

$("#calculated_final_fights_number").html(g_finals_fights);
$("#calculated_pre_final_fights_number").html(g_pre_finals_fights);


});

function g_read_values(){
  g_teams_number = parseInt($("#teams_number").val(),10)||0;
}
