class Player < ActiveRecord::Base
  has_many :fights, as: :shiro, dependent: :destroy
  has_many :fights, as: :aka, dependent: :destroy
  belongs_to :rank
  has_many :participations, dependent: :destroy
  has_many :tournaments, through: :participations
end
