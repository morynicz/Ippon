class Group < ActiveRecord::Base
  belongs_to :tournament
  has_many :fights
  has_many :players, through: :fights
end
