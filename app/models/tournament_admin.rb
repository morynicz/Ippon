class TournamentAdmin < ActiveRecord::Base
  belongs_to :user
  belongs_to :tournament

  enum status: {
    main: 0,
    field: 1
  }
end
