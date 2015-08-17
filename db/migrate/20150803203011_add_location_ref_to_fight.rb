class AddLocationRefToFight < ActiveRecord::Migration
  def change
    add_reference :fights, :location, index: true, foreign_key: true
  end
end
