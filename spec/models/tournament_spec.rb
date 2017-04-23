require 'rails_helper'

RSpec.describe Tournament, type: :model do
  describe "destroy" do
    let(:tournament) {FactoryGirl::create(:tournament_with_all)}
    let(:tournament_id) {tournament.id}
    context "when tournament with all possible children is destroyed" do
      it "destroys all participations" do
        tournament.destroy
        expect(TournamentParticipation.where(tournament_id: tournament_id)).to be_empty
      end
      it "destroys all teams" do
        tournament.destroy
        expect(Team.where(tournament_id: tournament_id)).to be_empty
      end
      it "destroys all locations" do
        tournament.destroy
        expect(Location.where(tournament_id: tournament_id)).to be_empty
      end
      it "destroys all tournament admins" do
        tournament.destroy
        expect(TournamentAdmin.where(tournament_id: tournament_id)).to be_empty
      end
      it "destroys all groups" do
        tournament.destroy
        expect(Group.where(tournament_id: tournament_id)).to be_empty
      end
      it "destroys all playoff fights" do
        tournament.destroy
        expect(PlayoffFight.where(tournament_id: tournament_id)).to be_empty
      end
    end
  end
end
