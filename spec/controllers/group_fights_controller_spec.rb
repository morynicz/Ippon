require 'rails_helper'

RSpec.describe GroupFightsController, type: :controller do
  render_views

  def authorize_user(tournament_id)
    TournamentAdmin.create(tournament_id: tournament_id,
      user_id: current_user.id, status: :main)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def expect_hash_eq_teamfight(hash, team_fight)
    expect(hash["id"]).to eq(team_fight.id)
    expect(hash["state"]).to eq(team_fight.state)
    expect(hash["shiro_team_id"]).to eq(team_fight.shiro_team_id)
    expect(hash["aka_team_id"]).to eq(team_fight.aka_team_id)
    expect(hash["shiro_score"]).to eq(team_fight.shiro_score)
    expect(hash["aka_score"]).to eq(team_fight.aka_score)
  end

  describe "GET show" do
    let(:action) {
      xhr :get, :show, format: :json, id: group_fight_id
    }

    let(:tournament) {
      FactoryGirl::create(:tournament)
    }
    let(:group) {
      FactoryGirl::create(:group, tournament: tournament)
    }

    subject(:results) {JSON.parse(response.body)}

    context "when the group fight exists" do
      let(:group_fight) {
        FactoryGirl::create(:group_fight, tournament: tournament)
      }

      let(:group_fight_id) {
        group_fight.id
      }

      it "should return 200 status" do
        action
        expect(response.status).to eq(200)
      end

      it "should return result with correct group" do
        action
        expect(results["group_fight"]["group_id"]).to eq(group_fight.
          group_id)
      end

      it "should return result with correct team fight" do
        action
        expect(results["group_fight"]["team_fight_id"]).to eq(group_fight.
          team_fight_id)
      end

      it "should return correct team fight data" do
        action
        expect_hash_eq_teamfight(results["team_fight"], group_fight.team_fight)
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
            authorize_user(group.tournament.id)
            action
            expect(results["is_admin"]).to be true
          end
        end
      end
    end

    context "when the group fight doesn't exist" do
      let(:group_fight_id) {-9999}
      it "should respond with 404 status" do
        action
        expect(response.status).to eq(404)
      end
    end
  end
end
