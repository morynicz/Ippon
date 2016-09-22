class TeamFightsController < ApplicationController
  before_filter :authenticate_user!, only: [:create]

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

  private

  def permitted_params
    params.require(:team_fight).permit(:id, :aka_team_id, :shiro_team_id,
      :state, :location_id)
  end

end
