class AddTournamentRefToGroup < ActiveRecord::Migration
  def change
    add_reference :groups, :tournament, index: true, foreign_key: true
  end
end
