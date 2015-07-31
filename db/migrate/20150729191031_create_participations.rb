class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.references :player, index: true, foreign_key: true
      t.references :tournament, index: true, foreign_key: true
      t.boolean :is_participating

      t.timestamps null: false
    end
  end
end
