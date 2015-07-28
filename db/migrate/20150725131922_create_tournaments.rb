class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :place
      t.integer :final_fight_len
      t.integer :group_fight_len
      t.timestamps null: false
    end
  end
end
