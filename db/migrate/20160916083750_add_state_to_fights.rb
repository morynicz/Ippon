class AddStateToFights < ActiveRecord::Migration
  def change
    add_column :fights, :state, :integer
  end
end
