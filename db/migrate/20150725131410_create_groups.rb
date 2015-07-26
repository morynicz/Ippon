class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.references :fight
      t.references :tournament
      t.timestamps null: false
    end
  end
end
