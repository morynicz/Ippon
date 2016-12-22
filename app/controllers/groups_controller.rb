class GroupsController < ApplicationController

  before_filter :authenticate_user!, only: [:create]

  def show
    @group = Group.find(params[:id])
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

  def create
    if user_signed_in?
      if TournamentAdmin.exists?(tournament_id: params[:tournament_id], user_id: current_user.id)
        @group = Group.new(permitted_params)
        if @group.valid?
          @group.save

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
    params.require(:group).permit(:id, :tournament_id, :name)
  end

  def authorize_user
    if user_signed_in?
      user = current_user
      group = Group.find(params[:id])
      tournament = Group.tournament
      head :unauthorized unless TournamentAdmin.exists?(tournament_id: tournament.id, user_id: user.id, status: TournamentAdmin.statuses[:main])
    else
      head :unauthorized
    end
  end
end
