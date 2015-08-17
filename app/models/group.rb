class Group < ActiveRecord::Base
  belongs_to :tournament
  has_many :fights
  has_many :group_members
  has_many :players, through: :group_members
end
