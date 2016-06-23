require 'spec_helper.rb'

feature "Viewing a list of Clubs", js: true do
  let(:club_list){FactoryGirl::create_list(:club, 10)}

  scenario "View all Clubs" do
    club_list
    visit "#/clubs"

    for club in club_list do
      expect(page).to have_content(club.name)
      expect(page).to have_content(club.city)
    end
  end
end
