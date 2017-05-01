require 'spec_helper.rb'

def fill_form(tournament)
  fill_in "name", with: tournament[:name]
  fill_in "city", with: tournament[:city]
  fill_in "address", with: tournament[:address]
  fill_in "date", with: tournament[:date]
  fill_in "playoff-fight-length", with: tournament[:playoff_match_length]
  fill_in "group-fight-length", with: tournament[:group_match_length]
  fill_in "team-size", with: tournament[:team_size]

  if tournament[:player_sex_constraint] == "no_constraint"
    choose "button-sex-mixed"
  else
    if tournament[:player_sex_constraint_value] == "women_only"
      choose "button-sex-woman"
    else
      choose "button-sex-man"
    end
  end

  select $ageConstraintMap[tournament[:player_age_constraint]], from: 'age-constraint-select'
  fill_in "age-constraint-value", with: tournament[:player_age_constraint_value] unless tournament[:player_age_constraint] == "age_no_constraint"
  select $rankConstraintMap[tournament[:player_rank_constraint]], from: 'rank-constraint-select'

  tokens = tournament[:player_rank_constraint_value].split('_')
  select "#{tokens[1]} #{tokens[0].upcase}", from: "rank-select" unless tournament[:player_rank_constraint] == "rank_no_constraint"

end

feature 'Creating editing and deleting a tournament', js: true do
  let(:tournament1) { FactoryGirl::attributes_for(:tournament)}
  let(:tournament2) { FactoryGirl::attributes_for(:tournament)}
  let(:user) { FactoryGirl::create(:user) }

  before do
    visit "#/home"
    visit "#/login"
    fill_in "email", with: user.email
    fill_in "password", with: user.password

    click_on "log-in-button"
    visit "#/home/"
  end

  scenario "Create a tournament when user exists", :raceable do
    visit "#/tournaments"

    click_on "new-tournament"

    fill_form(tournament1)
    click_on "save-tournament"
    expectPageToContainTournament(page, tournament1)
  end

  scenario "Update a tournament when user exists" do

    tournament2[:creator] = user
    tournament = Tournament.create(tournament2)
    visit "#/tournaments"

    click_on tournament2[:name]
    click_on "edit-tournament"

    fill_form(tournament1)
    click_on "save-tournament"
    expectPageToContainTournament(page, tournament1)
  end

  scenario "Cancel editing existing tournament" do
    tournament2[:creator] = user
    tournament = Tournament.create(tournament2)
    visit "#/tournaments"

    click_on tournament2[:name]
    click_on "edit-tournament"
    click_on "cancel-tournament"

    expectPageToContainTournament(page, tournament2)
  end

  scenario "Cancel creating a tournament" do
    Tournament.create(tournament1)
    tournament2[:creator] = user
    visit "#/tournaments"

    click_on "new-tournament"
    click_on "cancel-tournament"

    expect(page).to have_content(tournament1[:name])
    expect(page).to have_content(tournament1[:city])
  end

  scenario "Delete a tournament when user exists" do
    tournament2[:creator] = user
    tournament = Tournament.create(tournament2)
    tournament.save!
    tournament.reload
    id = tournament.id
    visit "#/tournaments"
    click_on tournament2[:name]
    click_on "delete-tournament"
    visit "#/tournaments"
    expect(Tournament.exists?(id)).to be(false)
  end
end
