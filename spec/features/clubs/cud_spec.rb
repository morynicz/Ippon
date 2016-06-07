require 'spec_helper.rb'

feature 'Creating editing and deleting a club', js: true do
  let(:cl1) { FactoryGirl::attributes_for(:club)}
  let(:cl2) { FactoryGirl::attributes_for(:club)}
  let(:user) { FactoryGirl::create(:user) }

  before do
    visit '#/login'

    fill_in "email", with: user.email
    fill_in "password", with: user.password

    click_on "Log In"
  end

  scenario "Create a club when user exists", :raceable do
    visit "#/clubs/"

    click_on "new-club"

    fill_in "name", with: cl1[:name]
    fill_in "city", with: cl1[:city]
    fill_in "description",with: cl1[:description]

    click_on "Save"

    expect(page).to have_content(cl1[:name])
    expect(page).to have_content(cl1[:city])
    expect(page).to have_content(cl1[:description])
  end

  scenario "Update a club when user exists" do

    club = Club.create(cl1)
    ClubAdmin.create(club_id: club.id, user_id: user.id)
    visit "#/clubs/"

    click_on cl1[:name]

    click_on "Edit"

    fill_in "name", with: cl2[:name]
    fill_in "city", with: cl2[:city]
    fill_in "description",with: cl2[:description]

    click_on "Save"

    expect(page).to have_content(cl2[:name])
    expect(page).to have_content(cl2[:city])
    expect(page).to have_content(cl2[:description])
  end

  scenario "Delete a club when user exists" do
    club = Club.create(cl1)
    ClubAdmin.create(club_id: club.id, user_id: user.id)

    visit "#/clubs/"

    click_on cl1[:name]
    click_on "delete-club"

    expect(Club.find_by_name(cl2[:name])).to be_nil
  end
end
