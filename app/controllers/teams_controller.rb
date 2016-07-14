class TeamsController < ApplicationController

  def show
    @team = Team.find(params[:id])
    if @team != nil && TeamMembership.exists?(team_id: @team.id)
      @players = Player.find(TeamMembership.select(:player_id).where(team_id: @team.id).map(&:player_id))
    else
      @players = []
    end
  end

end
