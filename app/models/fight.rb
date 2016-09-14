class Fight < ActiveRecord::Base
  belongs_to :team_fight
  belongs_to :aka, class_name: "Player", foreign_key: "aka_id"
  belongs_to :shiro, class_name: "Player", foreign_key: "shiro_id"
end
