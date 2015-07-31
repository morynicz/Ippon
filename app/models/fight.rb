class Fight < ActiveRecord::Base
  belongs_to :fightable, polymorphic: true
  belongs_to :shiro, class: 'Player'
  belongs_to :aka, class: 'Player'
  belongs_to :tournament, through: :fightable
  belongs_to :fight_state
  has_one :location
  has_one :state
end
