class Fight < ActiveRecord::Base
  validates :state, :team_fight_id, presence: true

  belongs_to :team_fight
  belongs_to :aka, class_name: "Player", foreign_key: "aka_id"
  belongs_to :shiro, class_name: "Player", foreign_key: "shiro_id"

  has_many :points, dependent: :destroy
  has_one :tournament, through: :team_fight

  enum state: {
    not_started: 0,
    started: 1,
    finished: 2
  }

  def aka_score
    player_score(shiro)
  end

  def shiro_score
    player_score(aka)
  end
  private

  def player_score(player)
    points.where(player_id: player.id).to_a.sum {|p| p.value}
  end

end
