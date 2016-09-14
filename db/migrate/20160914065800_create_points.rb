class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.references :fight, index: true, foreign_key: true
      t.references :player, index: true, foreign_key: true
      t.integer :type

      t.timestamps null: false
    end
  end
end
