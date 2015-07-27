class CreateFinalFights < ActiveRecord::Migration
  def change
    create_table :final_fights do |t|
      t.references :previous_aka_fight, index: true
      t.references :previous_shiro_fight, index: true
      t.references :fight
      t.references :tournament
      t.timestamps null: false
    end
  end
end
