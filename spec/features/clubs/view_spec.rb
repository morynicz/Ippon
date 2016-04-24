require 'spec_helper.rb'

cl1name = "New Club"
cl1city = "Oldville"
cl1description = "They just arrived"

cl2name = "Old Club"
cl2city = "Uppercastle"
cl2description = "Here for around 15 years already"

feature "Viewing a Club", js: true do
  before do
    club1 = Club.create!(
    name: cl1name,
    city: cl1city,
    description: cl1description);

    club2 = Club.create!(
    name: cl2name,
    city: cl2city,
    description: cl2description);
  end

  scenario "view one Club" do
    visit "#/clubs"
    click_on cl1name

    expect(page).to have_content(cl1name)
    expect(page).to have_content(cl1city)
    expect(page).to have_content(cl1description)

    click_on "Index"

    expect(page).to have_content(cl2name)
    expect(page).to_not have_content(cl2city)
    expect(page).to_not have_content(cl2description)

  end
end
