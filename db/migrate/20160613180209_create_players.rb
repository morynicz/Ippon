class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :surname
      t.date :birthday
      t.integer :rank
      t.integer :sex
      t.references :club, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
