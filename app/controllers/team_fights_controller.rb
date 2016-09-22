class TeamFightsController < ApplicationController
  before_filter :authenticate_user!, only: [:create]
  before_filter :authenticate_user!,:authorize_user, only: [:update]

  def show
    @team_fight = TeamFight.find(params[:id])
    if user_signed_in? && @team_fight != nil
      @isAdmin = TournamentAdmin.exists?(tournament_id: @team_fight.tournament
        .id, user_id: current_user.id, status: TournamentAdmin.statuses[:main])
    else
      @isAdmin = false
    end
  end

  def create
    if user_signed_in?
      #TODO: Fix this fugliness!
      if permitted_params[:shiro_team_id] != nil &&
          Team.exists?(permitted_params[:shiro_team_id])
        st = Team.find(permitted_params[:shiro_team_id])
        if TournamentAdmin.exists?(tournament_id: st.tournament.id,
            user_id: current_user.id, status: TournamentAdmin.statuses[:main])
          @team_fight = TeamFight.new(permitted_params)
          if @team_fight.valid?
            @team_fight.save

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
    team_fight = TeamFight.find(params[:id])
    if team_fight.update_attributes(permitted_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.require(:team_fight).permit(:id, :aka_team_id, :shiro_team_id,
      :state, :location_id)
  end

  def authorize_user
    if user_signed_in?
      user = current_user
      team_fight = TeamFight.find(params[:id])
      tournament = team_fight.tournament
      head :unauthorized unless TournamentAdmin.exists?(tournament_id:
        tournament.id, user_id: user.id, status: TournamentAdmin.statuses[:main])
    else
      head :unauthorized
    end
  end
end
