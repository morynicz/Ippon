class ParticipationsController < ApplicationController
  def new
    @participation = Participation.new
  end

  def index
  end

  def show
  end

  def create
    @player = Player.find(params[:player_id])
    @participation = @player.participations.build(participation_params)

    if @participation.save
      redirect_to "/players/#{@participation.player_id}/edit"
    else
      render '/new'
    end
  end

  def destroy
    @participation = Participation.find(params[:id])
    player_id = @participation.player_id
    @participation.destroy
    flash[:success] = :participaiton_deleted
    redirect_to "/players/#{player_id}/edit"
  end

  private
  def participation_params
    params.require(:participation).permit(:id,:player_id,:tournament_id)
  end
end
