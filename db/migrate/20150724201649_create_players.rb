class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :surname
      t.string :club
      t.references :rank
      t.timestamps null: false
    end
  end
end
