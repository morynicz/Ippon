class AddLocationToTeamFight < ActiveRecord::Migration
  def change
    add_reference :team_fights, :location, index: true, foreign_key: true
  end
end
