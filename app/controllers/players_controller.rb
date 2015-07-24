class PlayersController < ApplicationController

  def index
    @player = Player.new
    @players = Player.all
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)

    if @player.save
      redirect_to '/players'
    else
      render '/new'
    end
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    @player = Player.find(params[:id])

    if @player.update_attributes(player_params)
      redirect_to '/players'
    else
      render 'edit'
    end
  end

  private
  def player_params
    params.require(:player).permit(:name,:surname,:club,:rank)
  end
end
