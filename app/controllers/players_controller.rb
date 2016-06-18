class PlayersController < ApplicationController

  before_filter :authenticate_user!, only: [:create]
  before_filter :authenticate_user!,:authorize_user, only: [:update, :destroy]

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

  def create
    if user_signed_in?
      if permitted_params[:club_id] != nil
        if ClubAdmin.exists?(club_id: permitted_params[:club_id], user_id: current_user.id)
          @player = Player.new(permitted_params)
          if @player.valid?
            @player.save

            render 'show', status: 201
          else
            head :unprocessable_entity
          end
        else
          head :unauthorized
        end
      else
        head :unprocessable_entity
      end
    else
      head :unauthorized
    end
  end

  def update
    player = Player.find(params[:id])
    if player.update_attributes(permitted_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def destroy
    player = Player.find(params[:id])
    player.destroy
    head :no_content
  end

  private

  def permitted_params
    params.require(:player).permit(:name, :surname, :birthday, :rank, :sex, :club_id)
  end
end
