class PointsController < ApplicationController

  before_filter :authenticate_user!, only: [:create]

  def show
    @point = Point.find(params[:id])
  end

  def create
    if user_signed_in?
      if permitted_params[:fight_id] != nil &&
          Fight.exists?(permitted_params[:fight_id])
        fight = Fight.find(permitted_params[:fight_id])
        if TournamentAdmin.exists?(tournament_id: fight.tournament.id,
          user_id: current_user.id)
          @point = Point.new(permitted_params)
          if @point.valid?
            @point.save

            head :ok
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

  private

  def permitted_params
    params.require(:point).permit(:id, :player_id, :fight_id, :type)
  end
end
