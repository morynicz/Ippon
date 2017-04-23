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

  describe "Destruction" do
    let(:club) {FactoryGirl::create(:club_with_players_and_admins)}
    let(:club_id) {club.id}
    let(:players) {club.players.to_ary}

    it "destroys all it's admins" do
      club_id
      club.destroy
      expect(ClubAdmin.where(club_id: club_id)).to be_empty
    end

    it "nullifies all it's players" do
      players
      club.destroy

      for player in players do
        expect(Player.exists?(player.id)).to be(true)
        expect(Player.find(player.id).club_id).to be(nil)
      end
    end
  end
end
