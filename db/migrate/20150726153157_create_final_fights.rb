class CreateFinalFights < ActiveRecord::Migration
  def change
    create_table :final_fights do |t|
      t.belongs_to :previous_aka_fight
      t.belongs_to :previous_shiro_fight
      t.references :fight, index: true, foreign_key: true
      t.references :tournament, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
