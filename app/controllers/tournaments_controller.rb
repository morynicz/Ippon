require "#{Rails.root}/lib/TournamentUtils.rb"

class TournamentsController < ApplicationController
  include TournamentUtils

  def index
    @tournament = Tournament.new
    @tournaments = Tournament.all

  end

  def show
    @tournament = Tournament.find(params[:id])
    @groups = @tournament.groups
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)

    if @tournament.save
      redirect_to "/tournaments/#{@tournament.id}/edit"
    else
      render '/new'
    end
  end

  def edit
    @tournament = Tournament.find(params[:id])

    @location = Location.new
    @locations = @tournament.locations
    @players = @tournament.players
    @groups = @tournament.groups

    @groups_no, @four_team_groups, @three_team_groups, @two_team_groups, @groups_length, @finals_length, @pre_finals_fights,@finals_fights=process_tournament(@players.size,@tournament.group_fight_len,@tournament.final_fight_len,1,(@tournament.locations.empty?)?1:@tournament.locations.size)
  end

  def update
    @tournament = Tournament.(params[:id])

    if @tournament.update_attributes(tournament_params)
      redirect_to '/tournaments'
    else
      render 'edit'
    end
  end

  def destroy
    Tournament.find(params[:id]).destroy
    flash[:success] = :tournament_deleted
    redirect_to tournaments_url
  end

  def generate
    @tournament = Tournament.find(params[:id])
    group_no = params[:groups]
    finals = params[:finals_no]
    prefinals = params[:prefinals]

    two_g = params[:two_g]
    three_g = params[:three_g]
    four_g = params[:four_g]
    group_arr=[[1,0],[2,two_g.to_i],[3,three_g.to_i],[4,four_g.to_i]]

    letters = Array("A".."Z")
    locations =@tournament.locations.to_ary
    li=0
    puts group_arr
    0.upto(group_no.to_i - 1) {|i|
      loc = locations[li]
      li+=1
      li = li%locations.size
      gid = @tournament.groups.create(name: "#{letters[i]}")
      gr = Group.find_by_id(gid)
      puts "location #{loc.id}"
      gr.location_id = loc.id
      gr.save
    }

    players = @tournament.players.to_ary
    players.shuffle!
    group_arr.reverse!
    groups = @tournament.groups.to_ary

    group_arr.each {|g|
      puts"G #{g[0]} #{g[1]}"
      unless 0 == g[1]
        g[1].times {
          it=1
          group = groups.shift
          puts "n: #{group.name}"
          puts "Outer"
          g[0].times {
            puts "Inner"
            play = players.pop
            group.players << play
            member = GroupMember.find_by(player_id: play.id,group_id: group.id)
            member.position = "#{group.name}#{it}"
            member.save
            it += 1
          }
          puts "G #{group.name} end"
        }
      end
    }

    groups = @tournament.groups.to_ary

    puts "ls: #{locations.size}"
    groups.each {|gr|
      puts "G #{gr.name}"
      players = gr.players.to_ary
      fig = generate_group_fights(players)
      fig.each{|a,s|
        puts "#{a.name} vs #{s.name}"
        fight = Fight.new
        fight.aka_id = a.id
        fight.shiro_id = s.id
        fight.location_id = gr.location.id
        fight.fight_state_id = FightState.find_by_name!("Planned").id
        fight.aka_points = 0
        fight.shiro_points = 0
        fight.save
        gf = GroupFight.new
        gf.fight_id = fight.id
        gf.tournament_id = @tournament.id
        gf.group_id = gr.id
        gf.save
      }
    }

    puts "g#{group_no} f#{finals} p#{prefinals} 2: #{two_g} 3: #{three_g} 4: #{four_g}"
    redirect_to edit_tournament_path(@tournament)
  end

  private
  def tournament_params
    params.require(:tournament).permit(:name,:final_fight_len,:group_fight_len,:place)
  end
end
