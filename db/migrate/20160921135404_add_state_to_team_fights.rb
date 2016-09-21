class AddStateToTeamFights < ActiveRecord::Migration
  def change
    add_column :team_fights, :state, :integer
  end
end
