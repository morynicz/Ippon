class FightsController < ApplicationController

  def show

  end

  def edit
    @fight = Fight.find(params[:id])
  end

  def update
    @fight = Fight.find(params[:id])
    @group_fight = GroupFight.find_by(fight_id: @fight.id)
    @tournament= @group_fight.tournament
    #get the tournament
    if @fight.update_attributes(fight_params)
      redirect_to "/tournaments/#{@tournament.id}"
    else
      render 'edit'
    end
  end

  private
  def fight_params
    params.require(:fight).permit(:fight_state_id,:shiro_points,:aka_points)
  end
end
