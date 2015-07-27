class CreateFightStates < ActiveRecord::Migration
  def change
    create_table :fight_states do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
