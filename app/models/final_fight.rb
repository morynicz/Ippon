class FinalFight < ActiveRecord::Base
  has_one :fight
  belongs_to :tournament
  has_one :previous_aka_fight, class 'FightFight'
  has_one :previous_shiro_fight, class 'FinalFight' 
end
