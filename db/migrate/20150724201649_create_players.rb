class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :surname
      t.string :club
      t.integer :rank
      t.timestamps null: false
    end
  end
end
