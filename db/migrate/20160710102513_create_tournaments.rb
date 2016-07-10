class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.integer :state
      t.string :name
      t.integer :playoff_match_length
      t.integer :group_match_length
      t.integer :team_size
      t.integer :player_age_constraint
      t.integer :player_age_constraint_value
      t.integer :player_sex_constraint
      t.integer :player_sex_constraint_value
      t.integer :player_rank_constraint
      t.integer :player_rank_constraint_value

      t.timestamps null: false
    end
  end
end
