class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.references :tournament, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
