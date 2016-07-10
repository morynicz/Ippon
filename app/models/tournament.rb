class Tournament < ActiveRecord::Base
  enum state: {
    setup: 0,
    registration: 1,
    verification: 2,
    preparation: 3,
    groups: 4,
    playoff: 5,
    closed: 6
  }

  enum constraint: {
    no_constraint: 0,
    less_or_equal: 1,
    greater_or_equal: 2,
    equal: 3
  }
end
