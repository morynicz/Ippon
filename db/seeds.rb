# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#b1 = Book.create(title: "American Sniper", author: "Chris Kyle, Scott McEwen, Jim DeFelice", description: "A memoir about battlefield experiences in Iraq by the Navy SEALs sniper.", publisher: "Morrow/HarperCollins", weeks_on_list: 63, rank_this_week: 1)
1.upto(8) {|d|
  Rank.create(name: "#{d} Dan", is_dan: true)
}

5.downto(1){|k|
  Rank.create(name: "#{k} Kyu", is_dan: false)
}

FightState.create(name: 'Planned')
FightState.create(name: 'Started')
FightState.create(name: 'Finished')
