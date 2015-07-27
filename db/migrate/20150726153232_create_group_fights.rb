class CreateGroupFights < ActiveRecord::Migration
  def change
    create_table :group_fights do |t|
      t.references :fight
      t.references :tournament
      t.timestamps null: false
    end
  end
end
