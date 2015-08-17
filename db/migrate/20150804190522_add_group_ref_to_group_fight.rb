class AddGroupRefToGroupFight < ActiveRecord::Migration
  def change
    add_reference :group_fights, :group, index: true, foreign_key: true
  end
end
