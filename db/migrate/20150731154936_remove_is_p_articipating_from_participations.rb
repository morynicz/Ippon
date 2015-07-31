class RemoveIsPArticipatingFromParticipations < ActiveRecord::Migration
  def change
    remove_column :participations, :is_participating, :boolean
  end
end
