class GroupFightsController < ApplicationController
  def show
    @group_fight = GroupFight.find(params[:id])

    if user_signed_in? && @group_fight != nil
      @isAdmin = TournamentAdmin.exists?(tournament_id: @group_fight.group.tournament.id,
        user_id: current_user.id, status: TournamentAdmin.statuses[:main])
    else
      @isAdmin = false
    end
  end

  def index
    group = Group.find(params[:group_id])
    if group != nil
      @group_fights = group.group_fights
    else
      head :not_found
    end
  end
end
