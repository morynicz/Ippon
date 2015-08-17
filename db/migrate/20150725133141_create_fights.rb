class CreateFights < ActiveRecord::Migration
  def change
    create_table :fights do |t|
      t.integer :aka_points
      t.integer :shiro_points
      t.belongs_to :aka
      t.belongs_to :shiro
      t.timestamps null: false
    end
  end
end
