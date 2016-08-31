class CreateTournamentMemberships < ActiveRecord::Migration
  def change
    create_table :tournament_memberships do |t|
      t.references :player, index: true, foreign_key: true
      t.references :tournament, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
