class PlayersController < ApplicationController

  def authorize_user
    if user_signed_in?
      user = current_user
      player = find(params[:id])
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
end
