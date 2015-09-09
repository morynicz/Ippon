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
    @locations = @tournament.locations
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

  def calculate

  end

  def edit
    @tournament = Tournament.find(params[:id])

    @location = Location.new
    @participation = Participation.new

    @locations = @tournament.locations
    @players = @tournament.players
    @not_participants = Player.all - @players
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
    #no_of_members,no_of_groups,no_of_fights
    group_no_arr=[[1,0,0],[2,two_g.to_i,1],[3,three_g.to_i,3],[4,four_g.to_i,6]]

    letters = Array("A".."Z")
    locations =@tournament.locations.to_ary
    li=0

    group_no_arr.reverse!

    locs = Array.new(locations.size,0)
    loc_str =[]
    locs.size.times {
      loc_str << []
    }

    group_no_arr.each {|g|
      g[1].times {
        inx = locs.index(locs.min)
        locs[inx] += g[2];
        loc_str[inx] << g[0];
        puts "locs: #{locs}"
        puts "loc_str: #{loc_str}"
      }
    }

    name_i=0;

    players = @tournament.players.to_ary
    players.shuffle!

    0.upto(loc_str.size - 1) { |ln|
      loc = locations[ln]
      puts "loc: #{loc.name} lo: #{ln}"
      loc_str[ln].each {|l|
        puts "l: #{l}"
        gid = @tournament.groups.create({location_id: loc.id, name: "#{letters[name_i]}"})
        name_i+=1
        gr = Group.find_by_id(gid)
        1.upto(l){|it|
          play = players.pop
          gr.players << play
          member = GroupMember.find_by(player_id: play.id,group_id: gr.id)
          member.position = "#{gr.name}#{it}"
          member.save
        }
      }
    }

    groups = @tournament.groups.to_ary

    puts "ls: #{locations.size}"
    groups.each {|gr|
      puts "G #{gr.name}"
      players = gr.players.to_ary.sort { |p,q|
        GroupMember.find_by(player_id: p.id,group_id: gr.id).id <=>  GroupMember.find_by(player_id: q.id,group_id: gr.id).id
      }
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
