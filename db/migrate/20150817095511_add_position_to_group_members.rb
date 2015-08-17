class AddPositionToGroupMembers < ActiveRecord::Migration
  def change
    add_column :group_members, :position, :string
  end
end
