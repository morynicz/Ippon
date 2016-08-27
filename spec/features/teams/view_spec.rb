require 'spec_helper.rb'

feature "Viewing a Team", js: true do
    let(:t1) {FactoryGirl::create(:team_with_players)}
  scenario "view one Team" do
    t1
    visit "#/teams/" + t1.id.to_s

    expect(page).to have_content(t1.name)
    expect(page).to have_content(t1.required_size)

    members = t1.players

    for member in members do
      expect(page).to have_content(member.name)
      expect(page).to have_content(member.surname)
    end

  end
end
