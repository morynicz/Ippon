class PlayersController < ApplicationController

  before_filter :authenticate_user!,:authorize_user, only: [:update]

  def authorize_user
    if user_signed_in?
      user = current_user
      player = Player.find(params[:id])
      club = player.club
      head :unauthorized unless ClubAdmin.exists?(club_id: club.id, user_id: user.id)
    else
      head :unauthorized
    end
  end

  def index
    @players = Player.all
  end

  def show
    @player = Player.find(params[:id])
  end

  def update
    player = Player.find(params[:id])
    if player.update_attributes(params.require(:player).permit(:name, :surname, :birthday, :rank, :sex, :club_id))
      head :no_content
    else
      head :unprocessable_entity
    end
  end
end
