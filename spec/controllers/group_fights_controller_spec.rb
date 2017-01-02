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

  def extract_id
    ->(object) { object["id"]}
  end

  def extract_aka_team_id
    ->(object) { object["aka_team_id"]}
  end

  def extract_shiro_team_id
    ->(object) { object["shiro_team_id"]}
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

  def extract_team_fight
    ->(object) {object["team_fight"]}
  end

  def extract_group_fight
    ->(object) {object["group_fight"]}
  end

  def expect_hash_include_team_fight(hash,  team_fight)
    expect(hash.map(&extract_id)).to include(team_fight.id)
    expect(hash.map(&extract_state)).to include(team_fight.state)
    expect(hash.map(&extract_shiro_team_id)).to include(team_fight.shiro_team_id)
    expect(hash.map(&extract_aka_team_id)).to include(team_fight.aka_team_id)
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

  describe "GET index" do
    let(:tournament) {
      FactoryGirl::create(:tournament)
    }

    let(:group) {
      FactoryGirl::create(:group, tournament: tournament)
    }

    let(:group_fights) {
      FactoryGirl::create_list(:group_fight,10, group: group)
    }

    let(:action) {
      xhr :get, :index, format: :json, group_id: group.id
    }

    subject(:results) { JSON.parse(response.body)}

    context "when we want the full list" do
      it "should return 200 status" do
        group_fights
        action
        expect(response.status).to eq(200)
      end

      it "should return 10 results" do
        group_fights
        action
        expect(results.size).to eq(group.group_fights.size)
      end

      it "should include name and ids of the group fights" do
        group_fights
        action

        group_fight_ids = results.map(&extract_group_fight).map(&extract_id)

        for group_fight in group_fights do
          expect(group_fight_ids).to include(group_fight.id)
        end
      end

      it "should contain all the team fights of all the group fights" do
        group_fights
        action

        team_fights = results.map(&extract_team_fight)

        for group_fight in group_fights do
          expect_hash_include_team_fight(team_fights, group_fight.team_fight)
        end
      end
    end
  end
end
