class Player < ActiveRecord::Base
  has_many :fights, as: :shiro
  has_many :fights, as: :aka
  belongs_to :rank
end
