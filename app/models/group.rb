class Group < ActiveRecord::Base
  belongs_to :tournament
  has_many :group_fights
  has_many :group_members
  has_many :players, through: :group_members
  belongs_to :location
end
