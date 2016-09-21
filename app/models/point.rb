class Point < ActiveRecord::Base
  validates :type, :player_id, :fight_id, presence: true

  belongs_to :fight
  belongs_to :player
  has_one :tournament, through: :fight

  #no inheritance planned
  self.inheritance_column = :_type_disabled

  HANSOKU_VALUE = 0.5
  HIT_VALUE = 1

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

  def value
    case type.to_sym
    when :men, :kote, :do, :tsuki
      return HIT_VALUE
    when :hansoku
      return HANSOKU_VALUE
    end
  end
end
