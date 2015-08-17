class Fight < ActiveRecord::Base
  belongs_to :fightable, polymorphic: true
  belongs_to :shiro, class_name: 'Player'
  belongs_to :aka, class_name: 'Player'
  belongs_to :location
  belongs_to :fight_state
end
