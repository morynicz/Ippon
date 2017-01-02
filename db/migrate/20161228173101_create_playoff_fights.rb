class CreatePlayoffFights < ActiveRecord::Migration
  def change
    create_table :playoff_fights do |t|
      t.references :tournament, index: true, foreign_key: true
      t.references :team_fight, index: true, foreign_key: true
      t.references :previous_aka_fight, index: true
      t.references :previous_shiro_fight, index: true
      t.references :location, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
