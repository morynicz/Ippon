require 'spec_helper.rb'

feature "Viewing children", js: true do
  scenario "view all Teams" do
    tournament = FactoryGirl::create(:tournament_with_all)
    visit "#/tournaments"
    click_on tournament[:name]

    for team in tournament.teams
      expect(page).to have_content(team[:name])
    end
  end

  scenario "view Team details" do
    tournament = FactoryGirl::create(:tournament_with_all)
    visit "#/tournaments"
    click_on tournament[:name]

    team = tournament.teams.last
    within('section#teams-list') do
      click_on team[:name]
    end
    expect(page).to have_content(team[:name])
    for player in team.players
      expect(page).to have_content(player[:name])
      expect(page).to have_content(player[:surname])
      expect(page).to have_content(player[:club])
    end
  end

  scenario "get back from Team details to Tournament" do
    tournament = FactoryGirl::create(:tournament_with_all)
    visit "#/tournaments"
    click_on tournament[:name]
    team = tournament.teams.last
    within('section#teams-list') do
      click_on team[:name]
    end
    click_on "back-team"
    expect(page).to have_content(tournament[:name])
  end

  scenario "view Player in Team details" do
    tournament = FactoryGirl::create(:tournament_with_all)
    visit "#/tournaments"
    click_on tournament[:name]

    player = tournament.teams.last.players.last
    within('section#teams-list') do
      click_on player[:name]
    end
    expect(page).to have_content(player[:name])
    expect(page).to have_content(player[:surname])
    expect(page).to have_content(player[:club])
  end

  scenario "get back from Player details to Tournament" do
    tournament = FactoryGirl::create(:tournament_with_all)
    visit "#/tournaments"
    click_on tournament[:name]
    player = tournament.teams.last.players.last
    within('section#teams-list') do
      click_on player[:name]
    end
    click_on "back-player"
    expect(page).to have_content(tournament[:name])
  end
end