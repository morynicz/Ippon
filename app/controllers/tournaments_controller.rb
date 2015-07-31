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

    @groups, @four_team_groups, @three_team_groups, @two_team_groups, @groups_length, @finals_length=process_tournament(@players.size,@tournament.group_fight_len,@tournament.final_fight_len,1,@tournament.locations.size)
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

  private
  def tournament_params
    params.require(:tournament).permit(:name,:final_fight_len,:group_fight_len,:place)
  end
end
