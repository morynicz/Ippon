class TeamMembership < ActiveRecord::Base
  belongs_to :player
  belongs_to :team
  has_one :tournament, through: :team
end
