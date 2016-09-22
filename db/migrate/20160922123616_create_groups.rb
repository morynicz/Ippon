class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.references :tournament, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
