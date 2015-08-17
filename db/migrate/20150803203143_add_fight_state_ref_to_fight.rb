class AddFightStateRefToFight < ActiveRecord::Migration
  def change
    add_reference :fights, :fight_state, index: true, foreign_key: true
  end
end
