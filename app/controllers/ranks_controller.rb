class RanksController < ApplicationController

  def index
    @rank = Rank.new
    @ranks = Rank.all
  end

  def new
    @rank = Rank.new
  end

  def create
    @rank = Rank.new(rank_params)

    if @rank.save
      redirect_to '/ranks'
    else
      render '/new'
    end
  end

  def edit
    @rank = Rank.find(params[:id])
  end

  def update
    @rank = Rank.find(params[:id])

    if @rank.update_attributes(rank_params)
      redirect_to '/ranks'
    else
      render 'edit'
    end
  end

  private

  def rank_params
    params.require(:rank).permit(:name,:is_dan)
  end
end
