class Location < ActiveRecord::Base
  has_many :fights
  belongs_to :tournament
end
