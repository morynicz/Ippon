class CreateFinalFights < ActiveRecord::Migration
  def change
    create_table :final_fights do |t|

      t.timestamps null: false
    end
  end
end
