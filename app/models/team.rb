class Team < ActiveRecord::Base
  validates :name, :required_size, :tournament_id, presence: true
  belongs_to :tournament
end
