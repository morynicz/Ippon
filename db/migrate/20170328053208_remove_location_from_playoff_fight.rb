class RemoveLocationFromPlayoffFight < ActiveRecord::Migration
  def change
    remove_reference :playoff_fights, :location, index: true, foreign_key: true
  end
end
