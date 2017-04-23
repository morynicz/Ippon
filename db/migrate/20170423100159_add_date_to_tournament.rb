class AddDateToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :date, :date
  end
end
