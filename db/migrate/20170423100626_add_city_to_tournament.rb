class AddCityToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :city, :string
  end
end
