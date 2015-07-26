# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#b1 = Book.create(title: "American Sniper", author: "Chris Kyle, Scott McEwen, Jim DeFelice", description: "A memoir about battlefield experiences in Iraq by the Navy SEALs sniper.", publisher: "Morrow/HarperCollins", weeks_on_list: 63, rank_this_week: 1)
Rank.create(name: '5 Kyu', is_dan: false)
Rank.create(name: '4 Kyu', is_dan: false)
Rank.create(name: '3 Kyu', is_dan: false)
Rank.create(name: '2 Kyu', is_dan: false)
Rank.create(name: '1 Kyu', is_dan: false)
Rank.create(name: '1 Dan', is_dan: true)
Rank.create(name: '2 Dan', is_dan: true)
Rank.create(name: '3 Dan', is_dan: true)
Rank.create(name: '4 Dan', is_dan: true)
Rank.create(name: '5 Dan', is_dan: true)
Rank.create(name: '6 Dan', is_dan: true)
Rank.create(name: '7 Dan', is_dan: true)
Rank.create(name: '8 Dan', is_dan: true)
