require 'spec_helper.rb'

feature "Viewing a list of Players", js: true do
  let(:player_list){FactoryGirl::create_list(:player, 10)}

  scenario "View all Players" do
    player_list
    visit "#/players"

    for player in player_list do
      expect(page).to have_content(player.name)
      expect(page).to have_content(player.surname)
    end
  end
end
