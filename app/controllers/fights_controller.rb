class FightsController < ApplicationController

  before_filter :authenticate_user!, only: [:create]

  def show
    @fight = Fight.find(params[:id])
    @points = @fight.points
    if user_signed_in? && @fight != nil
      @isAdmin = TournamentAdmin.exists?(tournament_id: @fight.tournament.id, user_id: current_user.id, status: TournamentAdmin.statuses[:main])
    else
      @isAdmin = false
    end
  end

  def create
    if user_signed_in?
      if permitted_params[:team_fight_id] != nil &&
          TeamFight.exists?(permitted_params[:team_fight_id])
        tf = TeamFight.find(permitted_params[:team_fight_id])
        if TournamentAdmin.exists?(tournament_id: tf.tournament.id, user_id: current_user.id)
          @fight = Fight.new(permitted_params)
          if @fight.valid?
            @fight.save

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

  private

  def permitted_params
    params.require(:fight).permit(:id, :aka_id, :shiro_id, :state, :team_fight_id)
  end
end
