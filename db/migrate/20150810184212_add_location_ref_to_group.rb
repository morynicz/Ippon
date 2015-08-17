class AddLocationRefToGroup < ActiveRecord::Migration
  def change
    add_reference :groups, :location, index: true, foreign_key: true
  end
end
