class PlayoffFightsController < ApplicationController
  before_filter :authenticate_user!, only: [:create]
  before_filter :authenticate_user!, :authorize_user, only: [:update, :destroy]

  def show
    @playoff_fight = PlayoffFight.find(params[:id])

    if user_signed_in? && @playoff_fight != nil
      @isAdmin = TournamentAdmin.exists?(tournament_id: @playoff_fight.tournament.id,
        user_id: current_user.id, status: TournamentAdmin.statuses[:main])
    else
      @isAdmin = false
    end
  end

  def index
    torunament = Tournament.find(params[:torunament_id])
    if tournament != nil
      @playoff_fights = tournament.playoff_fights
    else
      head :not_found
    end
  end

  def create
    if user_signed_in?
      tournament = Tournament.find(params[:tournament_id])
      if tournament != nil && TournamentAdmin.exists?(tournament_id: tournament.id, user_id: current_user.id)
        @playoff_fight = PlayoffFight.new(permitted_params)
        if (params[:tournament_id].to_i == permitted_params[:tournament_id].to_i) && @playoff_fight.valid?
          @playoff_fight.save
          render 'show', status: 201
        else
          head :unprocessable_entity
        end
      else
        head :unauthorized
      end
    else
      head :unauthorized
    end
  end

  def update
    playoff_fight = PlayoffFight.find(params[:id])
    if playoff_fight.update_attributes(permitted_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def destroy
    playoff_fight = PlayoffFight.find(params[:id])
    playoff_fight.destroy
    head :no_content
  end

  private

  def permitted_params
    params.require(:playoff_fight).permit(:id, :tournament_id, :team_fight_id, :previous_aka_fight_id, :previous_shiro_fight_id)
  end

  def authorize_user
    if user_signed_in?
      playoff_fight = PlayoffFight.find(params[:id])
      head :unauthorized unless TournamentAdmin.exists?(tournament_id: playoff_fight.tournament.id,
        user_id: current_user.id, status: TournamentAdmin.statuses[:main])
    else
      head :unauthorized
    end
  end

end
