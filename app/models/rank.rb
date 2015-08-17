class Rank < ActiveRecord::Base
  has_many :players, dependent: :destroy
end
