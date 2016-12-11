class GroupsController < ApplicationController

  def show
    @group = Group.find(params[:group_id])
    @teams = @group.teams
    @team_fights = @group.team_fights
    if user_signed_in? && @group != nil
      @isAdmin = TournamentAdmin.exists?(tournament_id: params[:tournament_id], user_id: current_user.id, status: TournamentAdmin.statuses[:main])
    else
      @isAdmin = false
    end
  end

  def index
    tournament = Tournament.find(params[:tournament_id])
    if tournament != nil
      @groups = tournament.groups
    else
      head :not_found
    end
  end
end
