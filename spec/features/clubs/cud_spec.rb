require 'spec_helper.rb'

feature 'Creating editing and deleting a club', js: true do
  scenario "CRUD a club when user exists" do

    Cl = Struct.new("Cl", :name, :city, :description)
    cl1 = Cl.new("Nuclub", "Newville", "Some description")
    cl2 = Cl.new("UpClub", "Upcity", "Other desc")
    user = User.create!(username: "usr", email: "mail@mail.org", password: "passpasswd")

    visit '#/login'

    fill_in "email", with: user.email
    fill_in "password", with: user.password

    click_on "Log In"

    visit "#/clubs/"

    click_on "New Club..."

    fill_in "name", with: cl1.name
    fill_in "city", with: cl1.city
    fill_in "description",with: cl1.description

    click_on "Save"

    expect(page).to have_content(cl1.name)
    expect(page).to have_content(cl1.city)
    expect(page).to have_content(cl1.description)

    click_on "Edit"

    fill_in "name", with: cl2.name
    fill_in "city", with: cl2.city
    fill_in "description",with: cl2.description

    click_on "Save"

    expect(page).to have_content(cl2.name)
    expect(page).to have_content(cl2.city)
    expect(page).to have_content(cl2.description)

    visit "#/clubs/"

    click_on cl2.name
    click_on "delete-club"

    expect(Club.find_by_name(cl2.name)).to be_nil
  end
end
