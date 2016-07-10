class CreateTournamentAdmins < ActiveRecord::Migration
  def change
    create_table :tournament_admins do |t|
      t.references :user, index: true, foreign_key: true
      t.references :tournament, index: true, foreign_key: true
      t.integer :status

      t.timestamps null: false
    end
  end
end
