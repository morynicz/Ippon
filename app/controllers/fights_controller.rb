class FightsController < ApplicationController

  def show
    @fight = Fight.find(params[:id])
    @points = @fight.points
    if user_signed_in? && @fight != nil
      @isAdmin = TournamentAdmin.exists?(tournament_id: @fight.tournament.id, user_id: current_user.id, status: TournamentAdmin.statuses[:main])
    else
      @isAdmin = false
    end
  end
end
