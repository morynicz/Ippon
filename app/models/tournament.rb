class Tournament < ActiveRecord::Base
  has_many :final_fights
  has_many :group_fights
  has_many :fights, through: :final_fights
  has_many :fights, through: :group_fights
  has_many :locations
  has_many :participations
  has_many :players, through: :participations
  has_many :groups
end
