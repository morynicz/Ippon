require 'spec_helper.rb'

cl1attrs = FactoryGirl::attributes_for(:club)
cl2attrs = FactoryGirl::attributes_for(:club)

feature "Viewing a Club", js: true do
  before do
    club1 = Club.create!(cl1attrs);

    club2 = Club.create!(cl2attrs);
  end

  scenario "view one Club" do
    visit "#/clubs"
    click_on cl1name

    expect(page).to have_content(cl1attrs[:name])
    expect(page).to have_content(cl1attrs[:city])
    expect(page).to have_content(cl1attrs[:description])

    click_on "index-club"

    expect(page).to have_content(cl2attrs[:name])
    expect(page).to_not have_content(cl2attrs[:city])
    expect(page).to_not have_content(cl2attrs[:description])

  end
end
