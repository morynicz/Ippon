class PointsController < ApplicationController

  before_filter :authenticate_user!, only: [:create]
  before_filter :authenticate_user!,:authorize_user, only: [:update]

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

            render 'show', status: :ok
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
    point = Point.find(params[:id])
    if point.update_attributes(permitted_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.require(:point).permit(:id, :player_id, :fight_id, :type)
  end

  def authorize_user
    if user_signed_in?
      user = current_user
      point = Point.find(params[:id])
      tournament = point.tournament
      head :unauthorized unless TournamentAdmin.exists?(tournament_id: tournament.id, user_id: user.id, status: TournamentAdmin.statuses[:main])
    else
      head :unauthorized
    end
  end
end
