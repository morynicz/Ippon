class AddStatusToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :status, :integer, default: 0, null: false
  end
end
