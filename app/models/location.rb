class Location < ActiveRecord::Base
  belongs_to :tournament
  has_many :team_fights
  has_many :fights, through: :team_fights
end
