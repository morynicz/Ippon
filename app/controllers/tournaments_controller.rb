require "#{Rails.root}/lib/TournamentUtils.rb"

class TournamentsController < ApplicationController
  include TournamentUtils

  def index
    @tournament = Tournament.new
    @tournaments = Tournament.all

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

    @groups_no, @four_team_groups, @three_team_groups, @two_team_groups, @groups_length, @finals_length, @pre_finals_fights,@finals_fights=process_tournament(@players.size,@tournament.group_fight_len,@tournament.final_fight_len,1,@tournament.locations.size)
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

    letters = Array("a".."z")
    puts letters
    puts group_arr
    0.upto(group_no.to_i - 1) {|i|
      @tournament.groups.create(name: "#{letters[i]}")
    }

    players = @tournament.players.to_ary
    players.shuffle!
    group_arr.reverse!
    groups = @tournament.groups.to_ary

    group_arr.each {|g|
      puts"G #{g[0]} #{g[1]}"
      unless 0 == g[1]
        g[1].times {
          group = groups.shift
          puts "n: #{group.name}"
          puts "Outer"
          g[0].times {
            puts "Inner"
            group.players << players.pop
          }
          puts "G #{group.name} end"
        }
      end
    }

    puts "g#{group_no} f#{finals} p#{prefinals} 2: #{two_g} 3: #{three_g} 4: #{four_g}"
    redirect_to edit_tournament_path(@tournament)
  end

  private
  def tournament_params
    params.require(:tournament).permit(:name,:final_fight_len,:group_fight_len,:place)
  end
end
