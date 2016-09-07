class TournamentsController < ApplicationController
before_filter :authenticate_user!, only: [:create]
before_filter :authenticate_user!,:authorize_user, only: [:update, :destroy, :admins, :add_admin, :delete_admin, :add_participant, :delete_participant]

  def authorize_user
    if user_signed_in?
      user = current_user
      tournament = Tournament.find(params[:id])
      head :unauthorized unless TournamentAdmin.exists?(tournament_id: tournament.id, user_id: user.id, status: TournamentAdmin.statuses[:main])
    else
      head :unauthorized
    end
  end

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

  def update
    tournament = Tournament.find(params[:id])
    if tournament.update_attributes(permitted_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def destroy
    tournament = Tournament.find(params[:id])
    participations = TournamentParticipation.where(tournament_id: tournament.id)
    for participation in participations do
      participation.destroy
    end

    admins = TournamentAdmin.where(tournament_id: tournament.id)
    for admin in admins do
      admin.destroy
    end
    tournament.destroy
    head :no_content
  end

  def admins
    tournament = Tournament.find(params[:id])
    if user_signed_in? && TournamentAdmin.exists?(tournament_id: tournament.id, user_id: current_user.id)
      @admins = TournamentAdmin.where(tournament_id: tournament.id).collect {|ta| User.find(ta.user_id)}
      @users = User.all - @admins
    else
      @admins = []
      @users = []
    end
  end

  def add_admin
    user_id = params[:user_id]
    tournament_id = params[:id]
    if User.exists?(user_id) && Tournament.exists?(tournament_id) && !TournamentAdmin.exists?(tournament_id: tournament_id, user_id: user_id)
      add_admin_for_tournament(tournament_id,user_id)
      head :no_content
    else
      head :bad_request
    end
  end

  def delete_admin
    user_id = params[:user_id]
    tournament_id = params[:id]
    if User.exists?(user_id) && Tournament.exists?(tournament_id) && TournamentAdmin.exists?(tournament_id: tournament_id, user_id: user_id) && (TournamentAdmin.where(tournament_id: tournament_id).size > 1)
      admin= TournamentAdmin.find_by(tournament_id: tournament_id, user_id: user_id)
      admin.destroy
      head :no_content
    else
      head :bad_request
    end
  end

  def participants
    tournament = Tournament.find(params[:id])
    @participants = tournament.players
    @players = Player.all - @participants
  end

  def add_participant
    player = Player.find(params[:player_id])
    tournament = Tournament.find(params[:id])
    if player != nil && tournament != nil
      if !TournamentParticipation.exists?(tournament_id: tournament.id, player_id: player.id)
        TournamentParticipation.create(tournament_id: tournament.id, player_id: player.id)
        head :no_content
      else
        head :bad_request
      end
    else
      head :not_found
    end
  end

  def delete_participant
    player = Player.find(params[:player_id])
    tournament = Tournament.find(params[:id])
    if player != nil && tournament != nil
      if TournamentParticipation.exists?(tournament_id: tournament.id, player_id: player.id)
        participation = TournamentParticipation.find_by(tournament_id: tournament.id, player_id: player.id)
        participation.destroy

        membership_ids = tournament.team_memberships.ids
        if TeamMembership.exists?(player_id: player.id, id: membership_ids)
          member = TeamMembership.find_by(player_id: player.id, id: membership_ids)
          member.destroy
        end
        head :no_content
      else
        head :bad_request
      end
    else
      head :not_found
    end
  end

  private

  def add_admin_for_tournament(tournament_id, user_id)
    TournamentAdmin.create(tournament_id: tournament_id, user_id: user_id) unless TournamentAdmin.exists?(tournament_id: tournament_id, user_id: user_id)
  end

  def permitted_params
    par = params.require(:tournament).permit(:name,:playoff_match_length,:group_match_length,:team_size,:player_age_constraint,:player_age_constraint_value,:player_rank_constraint, :player_rank_constraint_value, :player_sex_constraint, :player_sex_constraint_value)
    par[:state] = :registration
    par
  end
end
