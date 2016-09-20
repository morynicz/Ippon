class Point < ActiveRecord::Base
  validates :type, :player_id, :fight_id, presence: true

  belongs_to :fight
  belongs_to :player
  has_one :tournament, through: :fight

  #no inheritance planned
  self.inheritance_column = :_type_disabled

  enum type: {
    men: 0,
    kote: 1,
    do: 2,
    tsuki: 3,
    hansoku: 4
  }

  def oponent
    if player.id == fight.aka.id
      fight.shiro
    else
      fight.aka
    end
  end
end
