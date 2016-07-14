class TeamsController < ApplicationController

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

  private

  def permitted_params
    params.require(:team).permit(:name, :required_size, :tournament_id)
  end
end
