class RemovePlayerSexConstraintFromTournament < ActiveRecord::Migration
  def change
    remove_column :tournaments, :player_sex_constraint, :integer
  end
end
