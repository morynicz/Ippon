class FightStatesController < ApplicationController
  def index
    @fight_state = FightState.new
    @fight_states = FightState.all
  end

  def new
    @fight_state = FightState.new
  end

  def create
    @fight_state = FightState.new(fight_state_params)

    if @fight_state.save
      redirect_to '/fight_states'
    else
      render '/new'
    end
  end

  def edit
    @fight_state = FightState.find(params[:id])
  end

  def update
    @fight_state = FightState.(params[:id])

    if @fight_state.update_attributes(fight_state_params)
      redirect_to '/fight_states'
    else
      render 'edit'
    end
  end

  private
  def fight_state_params
    params.require(:fight_state).permit(:name)
  end
end
