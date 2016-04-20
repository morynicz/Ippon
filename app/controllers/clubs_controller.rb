class ClubsController < ApplicationController
  def index
    @clubs = Club.all
  end

  def create
    @club = Club.new(params.require(:club).permit(:name, :city, :description))
    @club.save
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
    puts 'destroy?'
    club = Club.find(params[:id])
    club.destroy
    head :no_content
  end

  def show
    @club = Club.find(params[:id])
  end
end
