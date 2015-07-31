class FinalFight < ActiveRecord::Base
  has_one :fight
  belongs_to :tournament
  belongs_to :previous_aka_fight, class_name: 'FinalFight'
  belongs_to :previous_shiro_fight, class_name: 'FinalFight'
end
