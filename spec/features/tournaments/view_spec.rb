require 'spec_helper.rb'

feature "Viewing a Tournament", js: true do
    let(:tournament1) {FactoryGirl::attributes_for(:tournament_with_all)}
    let(:tournament2) {FactoryGirl::attributes_for(:tournament_with_all)}

  scenario "view one Tournament" do
    Tournament.create(tournament1)
    Tournament.create(tournament2)
    visit "#/tournaments"
    click_on tournament2[:name]
    expectPageToContainTournament(page,tournament2)
  end

  scenario "go back from Tournament to Tournament index" do
    Tournament.create(tournament1)
    Tournament.create(tournament2)
    visit "#/tournaments"
    click_on tournament1[:name]

    click_on "index-tournament"

    expect(page).to have_content(tournament1[:name])
    expect(page).to have_content(tournament1[:city])

    expect(page).to have_content(tournament2[:name])
    expect(page).to have_content(tournament2[:city])
  end
end