class TournamentsController < ApplicationController
before_filter :authenticate_user!, only: [:create]

  def create
    if user_signed_in?
      @tournament = Tournament.new(permitted_params)
      @tournament.creator = current_user
      if @tournament.valid?
        @tournament.save

        render 'show', status: 201
      else
        head :unprocessable_entity
      end
    else
      head :unauthorized
    end
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def index
    @tournaments = Tournament.all
  end

  private

  def permitted_params
    par = params.require(:tournament).permit(:name,:playoff_match_length,:group_match_length,:team_size,:player_age_constraint,:player_age_constraint_value,:player_rank_constraint, :player_rank_constraint_value, :player_sex_constraint, :player_sex_constraint_value)
    par[:state] = :registration
    par
  end
end
