class Tournament < ActiveRecord::Base
  has_many :final_fights, dependent: :destroy
  has_many :group_fights, dependent: :destroy
  has_many :fights, through: :final_fights
  has_many :fights, through: :group_fights
  has_many :locations, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :players, through: :participations
  has_many :groups, dependent: :destroy
end
