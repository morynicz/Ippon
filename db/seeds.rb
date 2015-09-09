# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#b1 = Book.create(title: "American Sniper", author: "Chris Kyle, Scott McEwen, Jim DeFelice", description: "A memoir about battlefield experiences in Iraq by the Navy SEALs sniper.", publisher: "Morrow/HarperCollins", weeks_on_list: 63, rank_this_week: 1)
rng = Random.new

5.downto(1){|k|
  Rank.create(name: "#{k} Kyu", is_dan: false)
}

1.upto(8) {|d|
  Rank.create(name: "#{d} Dan", is_dan: true)
}



FightState.create(name: 'Planned')
FightState.create(name: 'Started')
FightState.create(name: 'Finished')

1.upto(3+rng.rand(5)) { |t|
  to = Tournament.create(name: "To#{t}",place: "Pl#{t}",final_fight_len: 6,group_fight_len: 3)
  1.upto(1+rng.rand(3)) {|l|
    to.locations.create(name: "Lo#{l}")
  }
}

1.upto(60+rng.rand(60)) {|p|
  pl = Player.create(name: "Na#{p}",surname: "Su#{p}",club: "Cl#{p}",rank_id: Rank.all.sample.id )
  ts = Tournament.all.to_ary
  ts.shuffle!
  puts ts.size
  no = rng.rand(1..ts.size)
  puts no

  tts = ts.pop(no)

  tts.each {|t|
    pl.participations.create(player_id: pl.id, tournament_id: t.id)
  }
}
