class ClubsController < ApplicationController
  before_filter :authenticate_user!, only: [:create]
  before_filter :authenticate_user!,:authorize_user, only: [:update, :destroy, :admins]

  def authorize_user
    #head :unauthorized
    user = current_user
    club = Club.find(params[:id])

    head :unauathorized unless ClubAdmin.exists?(club_id: club.id, user_id: user.id)
  end

  def admins
    club = Club.find(params[:id])
    @admins = ClubAdmin.where(club_id: club.id).collect {|ca| User.find(ca.user_id)}
  end

  def index
    @clubs = Club.all
  end

  def create
    @club = Club.new(params.require(:club).permit(:name, :city, :description))
    @club.save

    puts "new club id #{@club.id}"
    add_admin_for_club(@club.id, current_user.id)
    render 'show', status: 201
  end

  def new
  end

  def update
    club = Club.find(params[:id])
    club.update_attributes(params.require(:club).permit(:name, :city, :description))
    head :no_content
  end

  def destroy
    club = Club.find(params[:id])
    club.destroy
    head :no_content
  end

  def show
    @club = Club.find(params[:id])
  end

  def add_admin_for_club(club_id, user_id)
    ClubAdmin.create(club_id: club_id, user_id: user_id) unless ClubAdmin.exists?(club_id: club_id, user_id: user_id)
  end

end
