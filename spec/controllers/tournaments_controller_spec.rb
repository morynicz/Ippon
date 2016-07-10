require 'rails_helper'

RSpec.describe TournamentsController, type: :controller do
  render_views

  describe "GET show" do
    let(:action) {
      xhr :get, :show, format: :json, id: tournament_id
    }

    subject(:results) {JSON.parse(response.body)}

    context "when the player exists" do
      let(:tournament) {
        FactoryGirl::create(:tournament)
      }
      let(:tournament_id){tournament.id}

      it "should return 200 status" do
        action
        expect(response.status).to eq(200)
      end

      it "should return result with correct id" do
        action
        expect(results["id"]).to eq(tournament.id)
      end

      it "should return result with correct name" do
        action
        expect(results["name"]).to eq(tournament.name)
      end

      it "should return result with team size" do
        action
        expect(results["team_size"]).to eq(tournament.team_size)
      end

      it "should return result with correct player age constraint" do
        action
        expect(results["player_age_constraint"]).to eq(tournament.player_age_constraint)
        expect(results["player_age_constraint_value"]).to eq(tournament.player_age_constraint_value)
      end

      it "should return result with correct player rank constraint" do
        action
        expect(results["player_rank_constraint"]).to eq(tournament.player_rank_constraint)
        expect(results["player_rank_constraint_value"]).to eq(tournament.player_rank_constraint_value)
      end

      it "should return result with correct player sex constraint" do
        action
        expect(results["player_sex_constraint"]).to eq(tournament.player_sex_constraint)
      end
    end

    context "when tournament doesn't exist" do
      let(:tournament_id) {-9999}
      it "should respond with 404 status" do
        action
        expect(response.status).to eq(404)
      end
    end
  end
end
