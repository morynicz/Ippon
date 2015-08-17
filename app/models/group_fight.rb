class GroupFight < ActiveRecord::Base
  has_one :fight
  belongs_to :tournament
  belongs_to :group
end
