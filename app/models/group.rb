class Group < ActiveRecord::Base
  belongs_to :tournament
  has_many :group_members, dependent: :destroy
  has_many :group_fights, dependent: :destroy
  has_many :teams, through: :group_members
  has_many :team_fights, through: :group_fights
end
