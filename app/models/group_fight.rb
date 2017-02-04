class GroupFight < ActiveRecord::Base
  validates :group_id, :team_fight_id, presence: true
  belongs_to :group
  belongs_to :team_fight
  has_one :tournament, through: :group
end
