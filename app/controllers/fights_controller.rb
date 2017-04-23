class FightsController < ApplicationController

  before_action :authenticate_user!, only: [:create]
  before_action :authenticate_user!,:authorize_user, only: [:update, :destroy]

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

  def update
    fight = Fight.find(params[:id])
    if fight.update_attributes(permitted_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def destroy
    fight = Fight.find(params[:id])
    fight.destroy
    head :no_content
  end

  private

  def permitted_params
    params.require(:fight).permit(:id, :aka_id, :shiro_id, :state, :team_fight_id)
  end

  def authorize_user
    if user_signed_in?
      user = current_user
      fight = Fight.find(params[:id])
      tournament = fight.tournament
      head :unauthorized unless TournamentAdmin.exists?(tournament_id: tournament.id, user_id: user.id, status: TournamentAdmin.statuses[:main])
    else
      head :unauthorized
    end
  end
end
