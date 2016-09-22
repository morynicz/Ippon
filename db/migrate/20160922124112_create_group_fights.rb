class CreateGroupFights < ActiveRecord::Migration
  def change
    create_table :group_fights do |t|
      t.references :group, index: true, foreign_key: true
      t.references :team_fight, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
