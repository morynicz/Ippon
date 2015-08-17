class Group < ActiveRecord::Base
  belongs_to :tournament
  has_many :group_fights, dependent: :destroy
  has_many :group_members, dependent: :destroy
  has_many :players, through: :group_members
  belongs_to :location
end
