class GroupFightsController < ApplicationController
  before_filter :authenticate_user!, only: [:create]

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

  def create
    if user_signed_in?
      group = Group.find(params[:group_id])
      if group != nil && TournamentAdmin.exists?(tournament_id: group.tournament.id, user_id: current_user.id)
        @group_fight = GroupFight.new(permitted_params)
        if (params[:group_id].to_i == permitted_params[:group_id].to_i) && @group_fight.valid?
          @group_fight.save
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

  private

  def permitted_params
    params.require(:group_fight).permit(:id, :group_id, :team_fight_id)
  end

  def authorize_user
    if user_signed_in?
      group_fight = GroupFight.find(params[:id])
      head :unauthorized unless TournamentAdmin.exists?(tournament_id: group_fight.group.tournament.id,
        user_id: current_user.id, status: TournamentAdmin.statuses[:main])
    else
      head :unauthorized
    end
  end
end
