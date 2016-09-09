require 'spec_helper.rb'

feature 'Adding and removing member of a team', js: true do
  let(:team1) { FactoryGirl::create(:team_with_players, {players_count: 2, required_size: 4})}
  let(:user) { FactoryGirl::create(:user) }
  let(:players) {
    FactoryGirl::create_list(:tournament_participation, 5, tournament: team1.tournament)
    team1.tournament.players - team1.players
  }

  before do
    visit "#/home"
    visit "#/login"
    fill_in "email", with: user.email
    fill_in "password", with: user.password

    click_on "log-in-button"
    visit "#/home/"

    TournamentAdmin.create(user_id: user.id, tournament_id: team1.tournament_id, status: :main)
    players
    visit "#/teams/" + team1.id.to_s

    click_on "edit-team"
  end

  scenario "Add member to a team when user exists and is a tournament admin", :raceable do
    p1 = players[0]

    within('h1', text: "#{p1.name} #{p1.surname}") do
      click_on "add-member"
    end

    within('h1', text: "#{p1.name} #{p1.surname}") do
      expect(page).to have_button("delete-member")
    end

    expect(TeamMembership.exists?(team_id: team1.id, player_id: p1.id)).to be true
  end

  scenario "Delete member from a team when user exists and is a tournament admin", :raceable do
    p1 = team1.players.first

    within('h1', text: "#{p1.name} #{p1.surname}") do
      click_on "delete-member"
    end

    within('h1', text: "#{p1.name} #{p1.surname}") do
      expect(page).to have_button("add-member")
    end

    expect(TeamMembership.exists?(team_id: team1.id, player_id: p1.id)).to be false
  end
end
