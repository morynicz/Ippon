class Fight < ActiveRecord::Base
  belongs_to :fightable, polymorphic: true
  belongs_to :shiro, polymorphic: true
  belongs_to :aka, polymorphic: true
  has_one :location
  has_one :state
end
