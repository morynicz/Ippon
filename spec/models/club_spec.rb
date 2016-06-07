require 'spec_helper'

describe Club do
  let(:creator) {
    FactoryGirl::create(:user)
  }

  let(:club_attrs) {
    FactoryGirl::attributes_for(:club)
  }
  describe "Creation with creator specified" do
    it "Adds creator as an admin after the club is created" do
      club_attrs["creator"] = creator
      club = Club.create(club_attrs)
      expect(ClubAdmin.exists?(club_id: club.id, user_id: creator.id)).to be true
    end
  end

  describe "Creation without creator specified" do
    it "Does not change admn count after the club is created" do
      expect {
        Club.create(club_attrs)
      }.not_to change(ClubAdmin, :count)
    end
  end
end
