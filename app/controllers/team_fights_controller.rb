class TeamFightsController < ApplicationController
  def show
    @team_fight = TeamFight.find(params[:id])
    if user_signed_in? && @team_fight != nil
      @isAdmin = TournamentAdmin.exists?(tournament_id: @team_fight.tournament
        .id, user_id: current_user.id, status: TournamentAdmin.statuses[:main])
    else
      @isAdmin = false
    end
  end
end
