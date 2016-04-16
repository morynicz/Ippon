class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.text :name
      t.text :city
      t.text :description

      t.timestamps null: false
    end
  end
end
