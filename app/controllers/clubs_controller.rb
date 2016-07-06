class ClubsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :is_admin, :where_admin]
  before_filter :authenticate_user!,:authorize_user, only: [:update, :destroy, :admins, :add_admin, :delete_admin]

  def authorize_user
    if user_signed_in?
      user = current_user
      club = Club.find(params[:id])
      head :unauthorized unless ClubAdmin.exists?(club_id: club.id, user_id: user.id)
    else
      head :unauthorized
    end
  end

  def index
    @clubs = Club.all
  end

  def create
    if user_signed_in?

      @club = Club.new(params.require(:club).permit(:name, :city, :description))
      @club.creator = current_user
      if @club.valid?
        @club.save

        render 'show', status: 201
      else
        head :unprocessable_entity
      end
    else
      head :unauthorized
    end
  end

  def new
  end

  def update
    club = Club.find(params[:id])
    if club.update_attributes(params.require(:club).permit(:name, :city, :description))
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def destroy
    club = Club.find(params[:id])
    admins = ClubAdmin.where(club_id: club.id)
    for admin in admins
      admin.destroy
    end
    club.destroy
    head :no_content
  end

  def show
    @club = Club.find(params[:id])
  end

  def admins
    club = Club.find(params[:id])
    if user_signed_in? && ClubAdmin.exists?(club_id: club.id, user_id: current_user.id)
      @admins = ClubAdmin.where(club_id: club.id).collect {|ca| User.find(ca.user_id)}
      @users = User.all - @admins
    else
      @admins = []
      @users = []
    end
  end

  def add_admin
    user_id = params[:user_id]
    club_id = params[:id]
    if User.exists?(user_id) && Club.exists?(club_id) && !ClubAdmin.exists?(club_id: club_id, user_id: user_id)
      add_admin_for_club(club_id,user_id)
      head :no_content
    else
      head :bad_request
    end
  end

  def delete_admin
    user_id = params[:user_id]
    club_id = params[:id]
    if User.exists?(user_id) && Club.exists?(club_id) && ClubAdmin.exists?(club_id: club_id, user_id: user_id) && (ClubAdmin.where(club_id: club_id).size > 1)
      admin= ClubAdmin.find_by(club_id: club_id, user_id: user_id)
      admin.destroy
      head :no_content
    else
      head :bad_request
    end
  end

  def add_admin_for_club(club_id, user_id)
    ClubAdmin.create(club_id: club_id, user_id: user_id) unless ClubAdmin.exists?(club_id: club_id, user_id: user_id)
  end

  def players
    club = Club.find(params[:id])
    @players = club.players
  end

  def is_admin
    if user_signed_in?
      club = Club.find(params[:id])
      if club != nil
        @is_admin =  ClubAdmin.exists?(club_id: club.id, user_id: current_user.id)
      else
        head :not_found
      end
    else
      head :unauthorized
    end
  end

  def where_admin
    if user_signed_in?
      @clubs = Club.find(ClubAdmin.select(:club_id).where(user_id: current_user.id).map(&:club_id))
    else
      head :unauthorized
    end
  end
end
