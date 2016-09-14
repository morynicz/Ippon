class CreateTeamFights < ActiveRecord::Migration
  def change
    create_table :team_fights do |t|
      t.references :shiro_team, index: true
      t.references :aka_team, index: true

      t.timestamps null: false
    end
  end
end
