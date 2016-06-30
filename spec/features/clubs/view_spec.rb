require 'spec_helper.rb'

feature "Viewing a Club", js: true do
  let(:club1) {FactoryGirl::create(:club_with_players, players_count: 5)}
  let(:club2) {FactoryGirl::create(:club)}

  scenario "view one Club" do
    players = club1.players
    club2
    visit "#/clubs"
    click_on club1.name

    expect(page).to have_content(club1.name)
    expect(page).to have_content(club1.city)
    expect(page).to have_content(club1.description)

    for player in players do
      expect(page).to have_content(player.name)
      expect(page).to have_content(player.surname)
    end

    click_on "index-club"

    expect(page).not_to have_content(club1.description)
    expect(page).not_to have_content(club2.description)
  end

  scenario "go from club to one of it's players" do
    players = club1.players
    club2
    visit "#/clubs"
    click_on club1.name

    for player in players do
      expect(page).to have_content(player.name)
      expect(page).to have_content(player.surname)
    end

    pl1 = players[0]
    click_on "#{pl1.name}-#{pl1.surname}-link"

    tokens = pl1.rank.split('_')
    expect(page).to have_content(pl1.name)
    expect(page).to have_content(pl1.surname)
    expect(page).to have_content("#{tokens[1]} #{tokens[0].upcase}")

  end
end
