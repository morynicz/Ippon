class TeamsController < ApplicationController

  before_filter :authenticate_user!, only: [:create]
  before_filter :authenticate_user!,:authorize_user, only: [:update, :destroy, :add_member, :delete_member]

  def authorize_user
    if user_signed_in?
      user = current_user
      team = Team.find(params[:id])
      tournament = team.tournament
      head :unauthorized unless TournamentAdmin.exists?(tournament_id: tournament.id, user_id: user.id, status: TournamentAdmin.statuses[:main])
    else
      head :unauthorized
    end
  end

  def show
    @team = Team.find(params[:id])
    if @team != nil && TeamMembership.exists?(team_id: @team.id)
      @players = Player.find(TeamMembership.select(:player_id).where(team_id: @team.id).map(&:player_id))
    else
      @players = []
    end
  end

  def create
    if user_signed_in?
      if permitted_params[:tournament_id] != nil
        if TournamentAdmin.exists?(tournament_id: permitted_params[:tournament_id], user_id: current_user.id)
          @team = Team.new(permitted_params)
          if @team.valid?
            @team.save

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
    team = Team.find(params[:id])
    if team.update_attributes(permitted_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def destroy
    team = Team.find(params[:id])
    memberships = TeamMembership.where(team_id: team.id)
    for membership in memberships do
      membership.destroy
    end
    team.destroy
    head :no_content
  end

  def add_member
    player = Player.find(params[:player_id])
    team = Team.find(params[:id])
    if player != nil && team != nil
      if !TeamMembership.exists?(team_id: team.id, player_id: player.id)
        TeamMembership.create(team_id: team.id, player_id: player.id)
        head :no_content
      else
        head :conflict
      end
    else
      head :not_found
    end
  end

  def delete_member
    player = Player.find(params[:player_id])
    team = Team.find(params[:id])
    if player != nil && team != nil
      if TeamMembership.exists?(team_id: team.id, player_id: player.id)
        member = TeamMembership.find_by(team_id: team.id, player_id: player.id)
        member.destroy
        head :no_content
      else
        head :not_found
      end
    else
      head :not_found
    end
  end

  private

  def permitted_params
    params.require(:team).permit(:name, :required_size, :tournament_id)
  end
end
