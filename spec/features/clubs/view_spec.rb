require 'spec_helper.rb'

feature "Viewing a Club", js: true do
  let(:club1) {FactoryGirl::create(:club)}
  let(:club2) {FactoryGirl::create(:club)}

  scenario "view one Club" do
    club1
    club2
    visit "#/clubs"
    click_on club1.name

    expect(page).to have_content(club1.name)
    expect(page).to have_content(club1.city)
    expect(page).to have_content(club1.description)

    click_on "index-club"

    expect(page).not_to have_content(club1.description)
    expect(page).not_to have_content(club2.description)

  end
end
