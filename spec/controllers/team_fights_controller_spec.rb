require 'rails_helper'

RSpec.describe TeamFightsController, type: :controller do
  render_views

  def extract_id
    ->(object) { object["id"]}
  end

  def extract_shiro_id
    ->(object) {object["shiro_id"]}
  end

  def extract_aka_id
    ->(object) {object["aka_id"]}
  end

  def extract_state
    ->(object) {object["state"]}
  end

  def authorize_user(tournament_id)
    TournamentAdmin.create(tournament_id: tournament_id,
      user_id: current_user.id, status: :main)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def compare_hash_with_team(hash, team)
    expect(team.name).to eq(hash["name"])
    expect(team.tournament_id).to eq(hash["tournament_id"])
  end

  describe "GET show" do
    let(:action) {
      xhr :get, :show, format: :json, id: team_fight_id
    }

    subject(:results) {JSON.parse(response.body)}

    context "when the fight exists" do
      let(:tournament) {FactoryGirl::create(:tournament, team_size: 3)}
      let(:team_fight) {
        FactoryGirl::create(:team_fight)
      }
      let(:team_fight_id){team_fight.id}

      it "should return 200 status" do
        action
        expect(response.status).to eq(200)
      end

      it "should return result with correct id" do
        action
        expect(results["team_fight"]["id"]).to eq(team_fight.id)
      end

      it "should return result with correct state" do
        action
        expect(results["team_fight"]["state"]).to eq(team_fight.state)
      end

      it "should return result with correct shiro team" do
        action
        expect(results["team_fight"]["shiro_team_id"]).to eq(team_fight.
          shiro_team_id)
      end

      it "should return result with correct aka team" do
        action
        expect(results["team_fight"]["aka_team_id"]).to eq(team_fight.
          aka_team_id)
      end

      it "should return result with correct shiro team score" do
        action
        expect(results["team_fight"]["shiro_score"]).to eq(team_fight.
          shiro_score)
      end

      it "should return result with correct aka team score" do
        action
        expect(results["team_fight"]["aka_score"]).to eq(team_fight.
          aka_score)
      end


      it "should return points with proper values" do
        action
        for fight in team_fight.fights do
          expect(results["fights"].map(&extract_id)).to include(fight.id)
          expect(results["fights"].map(&extract_state)).to include(fight.state)
          expect(results["fights"].map(&extract_shiro_id)).
            to include(fight.shiro_id)
          expect(results["fights"].map(&extract_aka_id)).
            to include(fight.aka_id)
        end
      end

      it "should return properly both teams" do
        action
        compare_hash_with_team(results["shiro_team"], team_fight.shiro_team)
        compare_hash_with_team(results["aka_team"], team_fight.aka_team)
      end

      context "when the user is not an admin" do
        it "should return admin status false" do
          action
          expect(results["is_admin"]).to be false
        end
      end

      context "when the user is authenticated", authenticated: true do
        context "when the user is an admin" do
          it "should return admin status true" do
            authorize_user(team_fight.tournament.id)
            action
            expect(results["is_admin"]).to be true
          end
        end
      end
    end

    context "when fight doesn't exist" do
      let(:team_fight_id) {-9999}
      it "should respond with 404 status" do
        action
        expect(response.status).to eq(404)
      end
    end
  end
end
