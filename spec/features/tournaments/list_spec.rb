require 'spec_helper.rb'

feature "Viewing a list of Tournaments", js: true do
  let(:tournament_list){FactoryGirl::create_list(:tournament, 10)}

  scenario "View all Tournaments" do
    tournament_list
    visit "#/tournaments"

    for tournament in tournament_list do
      expect(page).to have_content(tournament.name)
      expect(page).to have_content(tournament.city)
      expect(page).to have_content(tournament.date)
    end
  end
end