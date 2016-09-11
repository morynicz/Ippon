require 'spec_helper.rb'

feature 'Creating editing and deleting a team', js: true do
  let(:tournament1){ FactoryGirl::create(:tournament)}
  let(:tournament2){ FactoryGirl::create(:tournament)}
  let(:team1) { FactoryGirl::attributes_for(:team, tournament_id: tournament1.id)}
  let(:team2) { FactoryGirl::attributes_for(:team, tournament_id: tournament2.id)}
  let(:user) { FactoryGirl::create(:user) }

  before do
    visit "#/home"
    visit "#/login"
    fill_in "email", with: user.email
    fill_in "password", with: user.password

    click_on "log-in-button"
    visit "#/home/"
  end

  scenario "Update a team when user exists and is a tournament admin", :raceable do
    TournamentAdmin.create(user_id: user.id, tournament_id: tournament1.id, status: :main)
    tournament2
    t1 = Team.create(team1)

    #TODO: when tournament IF is done, enter properly
    visit "#/teams/" + t1.id.to_s

    click_on "edit-team"

    fill_in "name", with: team2[:name]

    click_on "save-team"

    expect(page).to have_content(team2[:name])
  end

  scenario "Cancel updating team when user exists and is a tournament admin", :raceable do
    TournamentAdmin.create(user_id: user.id, tournament_id: tournament1.id, status: :main)
    tournament2
    t1 = Team.create(team1)

    #TODO: when tournament IF is done, enter properly
    visit "#/teams/" + t1.id.to_s

    click_on "edit-team"

    fill_in "name", with: team2[:name]

    click_on "cancel-team"

    expect(page).to have_content(team1[:name])
  end

  scenario "Delete a team when user is a tournament admin" do
    TournamentAdmin.create(user_id: user.id, tournament_id: tournament1.id, status: :main)
    team = Team.create(team1)
    visit "#/teams/" + team.id.to_s

    click_on "delete-team"

    expect(Team.exists?(id: team.id)).to be false
  end
end
