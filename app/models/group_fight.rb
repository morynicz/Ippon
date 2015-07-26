class GroupFight < ActiveRecord::Base
  has_one :fight
  belongs_to :tournament
end
