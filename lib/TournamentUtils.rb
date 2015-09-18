module TournamentUtils
  def process_tournament(teams_number,group_fight_length,final_fight_length,players_number_per_team = 1,locations = 1)
    groups = teams_number
    finals_fights = 0
    pre_finals_fights = 0
    four_team_groups = 0
    three_team_groups = 0
    two_team_groups = 0
    finals_length = 0

    alg_table= [[1,0,1,0],[2,0,2,1],[4,1,0,0],[8,2,4,3],[16,4,8,7],[24,6,12,11],[32,8,16,15],[48,12,24,23],[64,16,32,31],[96,24,48,37],[128,32,64,63],[192,48,96,81]]

    i=0
    ni = 0
    gi = 1
    fi = 2
    ffi = 3

    while (i < alg_table.size) && ( teams_number > alg_table[i][ni])
      i+= 1
    end

    groups = alg_table[i][gi]
    finalists = alg_table[i][fi]
    final_fight_no = alg_table[i][ffi]

    if groups > 0
      garr = Array.new(groups,0)

      j=0
      teams_number.times {
        garr[j] += 1
        j += 1
        j = j % groups
        puts "gi: #{j} garr: #{garr}"
      }

      four_team_groups = garr.count(4)
      three_team_groups = garr.count(3)
      two_team_groups = garr.count(2)
    end

    finals_fights = (alg_table[i][ffi] > 7 ) ? 7 : alg_table[i][ffi]
    pre_finals_fights = (alg_table[i][ffi] > 7 ) ? alg_table[i][ffi] - 7 : 0

    groups_length = ((four_team_groups * 6  + three_team_groups * 3 + two_team_groups) * players_number_per_team * group_fight_length) / locations
    groups_length += pre_finals_fights * players_number_per_team * final_fight_length / locations

    unless finals_fights == 0
      finals_length = (((finals_fights - 3) / ((locations >1)?2:1)+ 3)) * final_fight_length * players_number_per_team
    end

    return groups, four_team_groups, three_team_groups, two_team_groups, groups_length, finals_length, pre_finals_fights,finals_fights
  end

  def generate_group_fights(players)
    if 4 == players.size
      return [[players[0],players[1]],[players[2],players[1]],[players[2],players[3]],[players[0],players[3]],[players[0],players[2]],[players[1],players[3]]]
    elsif 3 == players.size
      return [[players[0],players[1]],[players[2],players[1]],[players[2],players[0]]]
    else
      return players.combination(2)
    end
  end
end
