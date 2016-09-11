class RemoveRequiredSizeFromTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :required_size, :integer
  end
end
