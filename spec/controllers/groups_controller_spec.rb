require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  render_views

  def extract_id
    ->(object) { object["id"]}
  end

  def extract_aka_team_id
    ->(object) { object["aka_team_id"]}
  end

  def extract_shiro_team_id
    ->(object) { object["shiro_team_id"]}
  end

  def authorize_user(tournament_id)
    TournamentAdmin.create(tournament_id: tournament_id,
      user_id: current_user.id, status: :main)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def compare_group_with_hash(hash, group)
    expect(group.id).to eq(hash["id"])
    expect(group.name).to eq(hash["name"])
    expect(group.tournament_id).to eq(hash["tournament_id"])
  end

  describe "GET show" do
    let(:action) {
      xhr :get, :show, format: :json, id: tournament.id, group_id: group_id
    }

    let(:tournament) {
      FactoryGirl::create(:tournament)
    }

    subject(:results) {JSON.parse(response.body)}

    context "when the group exists" do
      let(:group) {
        FactoryGirl::create(:group_with_fights, tournament: tournament)
      }

      let(:group_id) {
        group.id
      }

      it "should return 200 status" do
        action
        expect(response.status).to eq(200)
      end

      it "should return result with correct id" do
        action
        expect(results["group"]["id"]).to eq(group.id)
      end

      it "should return result with correct name" do
        action
        expect(results["group"]["name"]).to eq(group.name)
      end

      it "should return result with correct tournament" do
        action
        expect(results["group"]["tournament_id"]).to eq(group.
          tournament_id)
      end

      it 'should return all group members' do
        action
        for team in group.teams do
          expect(results["teams"].map(&extract_name)).to include(team.name)
          expect(results["teams"].map(&extract_id)).to include(team.id)
        end
      end

      it 'should return all team fights' do
        action
        for team_fight in group.team_fights do
          expect(results["team_fights"].map(&extract_id)).to include(team_fight.id)
          expect(results["team_fights"].map(&extract_shiro_team_id)).to include(team_fight.shiro_team_id)
          expect(results["team_fights"].map(&extract_aka_team_id)).to include(team_fight.aka_team_id)
        end
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

    context "when the group doesn't exist" do
      let(:group_id) {-9999}
      it "should respond with 404 status" do
        action
        expect(response.status).to eq(404)
      end
    end
  end
end