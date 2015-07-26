class FinalFight < ActiveRecord::Base
  has_one :fight
  belongs_to :tournament
  has_one :previous_aka_fight, class_name: 'FinalFight'
  has_one :previous_shiro_fight, class_name: 'FinalFight'
end
