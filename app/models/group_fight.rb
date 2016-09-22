class GroupFight < ActiveRecord::Base
  belongs_to :group
  belongs_to :team_fight
end
