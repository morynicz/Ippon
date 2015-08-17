class LocationsController < ApplicationController
  def index
    @location = Location.new
    @locations = Location.all
  end

  def new
    @tournament = Tournament.find(params[:tournament_id])
    @location = Location.new
  end

  def create
    @tournament = Tournament.find(params[:tournament_id])
    @location = @tournament.locations.build(location_params)
    if @location.save
      redirect_to "/tournaments/#{@location.tournament_id}/edit"
    else
      render 'edit'
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])

    if @location.update_attributes(loaction_params)
      redirect_to "/tournaments/#{@location.tournament_id}/edit"
    else
      render 'edit'
    end
  end

  def destroy
    @location = Location.find(params[:id])
    tournament_id = @location.tournament_id
    @location.fights.destroy_all
    @location.destroy
    flash[:success] = :location_deleted
    redirect_to "/tournaments/#{tournament_id}/edit"
  end

  private
  def location_params
    params.require(:location).permit(:name,:tournament_id)
  end
end
