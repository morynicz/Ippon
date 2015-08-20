module TournamentUtils
  def process_tournament(teams_number,group_fight_length,final_fight_length,players_number_per_team = 1,locations = 1)
    groups = teams_number
    finals_fights = 0
    pre_finals_fights = 0
    four_team_groups = 0
    three_team_groups = 0
    two_team_groups = 0
    finals_length = 0

    unless teams_number == 17
      ti = 0
      gi = 1
      fi = 2

      alg_table = [[5,1,0],[9,2,3],[13,3,5],[17,4,7],[25,6,11],[37,8,15],[49,12,21],[65,16,31]]
      i=0

      while (i < alg_table.size - 1) && teams_number >= alg_table[i][ti]
        i+= 1
      end
      groups = alg_table[i][gi]
      finals_fights = (alg_table[i][fi] > 7 ) ? 7 : alg_table[i][fi]
      pre_finals_fights = (alg_table[i][fi] > 7 ) ? alg_table[i][fi] - 7 : 0

      four_team_groups = (teams_number > 3) ? teams_number - groups * 3 : 0
      three_team_groups = (teams_number > 2 ) ? groups - four_team_groups : 0
    else
      groups = 6
      four_team_groups = 0
      three_team_groups = 5
    end
    two_team_groups = (teams_number > 1) ? groups - four_team_groups - three_team_groups : 0

    groups_length = ((four_team_groups * 6  + three_team_groups * 3 + two_team_groups) * players_number_per_team * group_fight_length) / locations
    groups_length += pre_finals_fights * players_number_per_team * final_fight_length / locations

    unless finals_fights == 0
      finals_length = (((finals_fights - 3) / ((locations >1)?2:1)+ 3)) * final_fight_length * players_number_per_team
    end

    return groups, four_team_groups, three_team_groups, two_team_groups, groups_length, finals_length, pre_finals_fights,finals_fights
  end

  def generate_group_fights(players)
    return players.combination(2)
  end
end
