class TournamentsController < ApplicationController
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
  end

  def update
    @tournament = Tournament.(params[:id])

    if @tournament.update_attributes(tournament_params)
      redirect_to '/tournaments'
    else
      render 'edit'
    end
  end

  private
  def tournament_params
    params.require(:tournament).permit(:name,:final_fight_len,:group_fight_len,:place)
  end
end
