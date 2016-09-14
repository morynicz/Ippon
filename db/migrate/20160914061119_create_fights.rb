class CreateFights < ActiveRecord::Migration
  def change
    create_table :fights do |t|
      t.references :team_fight, index: true, foreign_key: true
      t.references :aka, index: true, null: false
      t.references :shiro, index: true, null: false

      t.timestamps null: false
    end
  end
end
