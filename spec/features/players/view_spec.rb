require 'spec_helper.rb'

feature "Viewing a Player", js: true do
    let(:p1) {FactoryGirl::create(:player)}
    let(:p2) {FactoryGirl::create(:player)}

  scenario "view one Player" do
    p1
    p2
    visit "#/players"
    click_on "#{p1.name} #{p1.surname}"
    tokens = p1.rank.split('_')

    expect(page).to have_content(p1.name)
    expect(page).to have_content(p1.surname)
    expect(page).to have_content("#{tokens[1]} #{tokens[0].upcase}")
    expect(page).to have_content(Club.find_by_id(p1.club_id).name)
  end

  scenario "go back from Player to Player index" do
    p1
    p2
    visit "#/players"
    click_on "#{p1.name} #{p1.surname}"

    click_on "index-player"

    expect(page).to have_content(p1.name)
    expect(page).to have_content(p1.surname)

    expect(page).to have_content(p2.name)
    expect(page).to have_content(p2.surname)
  end

  scenario "go from Player to his Club" do
    p1
    club = Club.find_by_id(p1.club_id)
    visit "#/players"
    click_on "#{p1.name} #{p1.surname}"

    click_on club.name

    expect(page).to have_content(club.name)
    expect(page).to have_content(club.city)
    expect(page).to have_content(club.description)
  end
end
