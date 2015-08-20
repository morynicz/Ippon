var g_teams_number = 0
var g_finals_fights = 0
var  g_pre_finals_fights = 0
var  g_four_team_groups = 0
var  g_three_team_groups = 0
var  g_two_team_groups = 0

$(document).on("input",".to_calculate", function () {
  g_read_values();
  if (g_teams_number != 17) {
    var ti = 0
    var gi = 1
    var fi = 2

    var alg_table = [[5,1,0],[9,2,3],[13,3,5],[17,4,7],[25,6,11],[37,8,15],[49,12,21],[65,16,31]]
    var i=0

    while ((i < alg_table.length - 1) && g_teams_number >= alg_table[i][ti]) {
      i+= 1
    }
    g_groups = alg_table[i][gi]
    g_finals_fights = (alg_table[i][fi] > 7 ) ? 7 : alg_table[i][fi]
    g_pre_finals_fights = (alg_table[i][fi] > 7 ) ? alg_table[i][fi] - 7 : 0

    g_four_team_groups = (g_teams_number > 3) ? g_teams_number - g_groups * 3 : 0
    g_three_team_groups = (g_teams_number > 2 ) ? g_groups - g_four_team_groups : 0
  } else {
    g_groups = 6
    g_four_team_groups = 0
    g_three_team_groups = 5
  }

  g_two_team_groups = (g_teams_number > 1) ? g_groups - g_four_team_groups - g_three_team_groups : 0

$("#calculated_four_team_groups").html(g_four_team_groups);
$("#calculated_three_team_groups").html(g_three_team_groups);
$("#calculated_two_team_groups").html(g_two_team_groups);
$("#calculated_groups").html(g_groups);


});

function g_read_values(){
  g_teams_number = parseInt($("#teams_number").val(),10)||0;
}
