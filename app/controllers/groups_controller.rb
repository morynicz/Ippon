class GroupsController < ApplicationController

  before_filter :authenticate_user!, only: [:create]
  before_filter :authenticate_user!,:authorize_user, only: [:update, :destroy]

  def show
    @group = Group.find(params[:id])
    @teams = @group.teams
    @team_fights = @group.team_fights

    if user_signed_in? && @group != nil
      @isAdmin = TournamentAdmin.exists?(tournament_id: @group.tournament.id, user_id: current_user.id, status: TournamentAdmin.statuses[:main])
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

  def update
    group = Group.find(params[:id])
    if group.update_attributes(permitted_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def destroy
    group = Group.find(params[:id])
    group.destroy
    head :no_content
  end

  private

  def permitted_params
    params.require(:group).permit(:id, :tournament_id, :name)
  end

  def authorize_user
    if user_signed_in?
      group = Group.find(params[:id])
      head :unauthorized unless TournamentAdmin.exists?(tournament_id: group.tournament.id,
        user_id: current_user.id, status: TournamentAdmin.statuses[:main])
    else
      head :unauthorized
    end
  end
end
