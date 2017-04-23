class Location < ActiveRecord::Base
  belongs_to :tournament
  has_many :team_fights, dependent: :destroy
  has_many :fights, through: :team_fights
end
