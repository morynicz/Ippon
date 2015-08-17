class Location < ActiveRecord::Base
  has_many :fights, dependent: :destroy
  belongs_to :tournament
  has_many :groups
end
