class AddAddressToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :address, :string
  end
end
