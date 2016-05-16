class ClubsController < ApplicationController
  before_filter :authenticate_user!, :derp, only: [:create]
  before_filter :authenticate_user!,:authorize_user, only: [:update, :destroy, :admins, :add_admin, :delete_admin]

  def derp
    puts "derp: #{user_signed_in?}"
  end

  def authorize_user
    user = current_user
    club = Club.find(params[:id])
    head :unauathorized unless ClubAdmin.exists?(club_id: club.id, user_id: user.id)
  end

  def index
    @clubs = Club.all
  end

  def create
    puts "create: #{user_signed_in?}"
    @club = Club.new(params.require(:club).permit(:name, :city, :description))
    @club.creator = current_user
    @club.save

    puts "#{@club.id} #{@club.name} #{@club.creator}"
    #add_admin_for_club(@club.id, current_user.id)
    render 'show', status: 201
  end

  def new
  end

  def update
    puts "update: #{user_signed_in?}"
    club = Club.find(params[:id])
    club.update_attributes(params.require(:club).permit(:name, :city, :description))
    head :no_content
  end

  def destroy
    puts "destroy: #{user_signed_in?}"
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
    end
    head :no_content
  end

  def delete_admin
    user_id = params[:user_id]
    club_id = params[:id]
    if User.exists?(user_id) && Club.exists?(club_id) && (ClubAdmin.where(club_id: club_id).size > 1)
      admin= ClubAdmin.find_by(club_id: club_id, user_id: user_id)
      admin.destroy
    end
    head :no_content
  end

  def add_admin_for_club(club_id, user_id)
    ClubAdmin.create(club_id: club_id, user_id: user_id) unless ClubAdmin.exists?(club_id: club_id, user_id: user_id)
  end

end
