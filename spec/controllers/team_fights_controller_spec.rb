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

  def compare_hash_with_team_fight(hash, team_fight)
    expect(team_fight.aka_team_id).to eq(hash["aka_team_id"])
    expect(team_fight.shiro_team_id).to eq(hash["shiro_team_id"])
    expect(team_fight.location_id).to eq(hash["location_id"])

    expect(team_fight.shiro_score).to eq(hash["shiro_score"]) if hash[
      "shiro_score"] != nil
    expect(team_fight.aka_score).to eq(hash["aka_score"]) if hash[
      "aka_score"] != nil
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

  describe "POST :create" do
    let(:tournament) {FactoryGirl::create(:tournament)}
    let(:attributes) { attributes_with_foreign_keys(:team_fight,
       tournament: tournament)}
    let(:action) do
        xhr :post, :create, format: :json, team_fight: attributes
    end

    subject(:results) {JSON.parse(response.body)}

    context "when the user is not authenticated" do
      it "does not create a team fight" do
        expect {
          action
        }.to_not change(TeamFight, :count)
      end

      it "denies access" do
        action
        expect(response).to have_http_status :unauthorized
      end
    end

    context "when the user is authenticated", authenticated: true do
      context "when user is authorized" do
        before do
          authorize_user(tournament.id)
        end

        context "with invalid attributes" do

          let(:attributes) do
            {
              location_id: '',
              aka_team_id: '',
              shiro_team_id: '',
              state: ''
            }
          end

          it "does not create a team fight" do
            expect {
              action
            }.to_not change(TeamFight, :count)
          end

          it "returns the correct status" do
            action
            expect(response).to have_http_status :unprocessable_entity
          end
        end

        context "with valid attributes" do
          it "creates a team fight" do
            expect {
              action
            }.to change(TeamFight, :count).by(1)
          end

          it "returns the correct status" do
            action
            expect(response).to be_successful
          end

          it "creates a fight with proper values" do
            action
            tf = TeamFight.find(results["team_fight"]["id"])
            compare_hash_with_team_fight(attributes, tf)
          end
        end
      end

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "does not create a team fight" do
          expect {
            action
          }.to_not change(TeamFight, :count)
        end
      end
    end
  end

  describe "PATCH update" do
    let(:tournament) {FactoryGirl::create(:tournament)}

    let(:action) {
      xhr :put, :update, format: :json, id: team_fight.id,
        team_fight: update_attrs
      team_fight.reload
    }

    let(:update_attrs) {
        attributes_with_foreign_keys(:team_fight, tournament: tournament)
    }
    let(:attrs) {
      attributes_with_foreign_keys(:team_fight, tournament: tournament)
    }
    context "when the team fight exists" do
      let(:team_fight) {
        TeamFight.create(attrs)
      }

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(tournament.id)
        end
        context "when the update atttributes are valid" do
          it "should return correct status" do
            action
            expect(response.status).to eq(204)
          end

          it "should update team fight attributes" do
            action
            compare_hash_with_team_fight(update_attrs, team_fight)
          end
        end

        context "when the update attributes are not valid" do
          let(:update_attrs) {
            {
              location_id: '',
              aka_team_id: '',
              shiro_team_id: '',
              state: ''
            }
          }

          it "should not update team team attributes" do
            action
            compare_hash_with_team_fight(attrs, team_fight)
          end

          it "should return unporcessable entity" do
            action
            expect(response).to have_http_status :unprocessable_entity
          end
        end
      end

      context "when the user isn't authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "should not update team fight attributes" do
          action
          compare_hash_with_team_fight(attrs, team_fight)
        end
      end
    end

    context "when the team fight doesn't exist" do
      let(:team_fight_id) {-9999}

      let(:action) {
        xhr :put, :update, format: :json, id: team_fight_id, team: update_attrs
      }

      context "when user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end

  describe "DELETE: destroy" do
    let(:tournament) {FactoryGirl::create(:tournament)}

    let(:action) {
        xhr :delete, :destroy, format: :json, id: team_fight_id
    }

    context "when the team fight exists" do
      let(:team_fight) {
        FactoryGirl::create(:team_fight_with_fights_and_points,
          tournament: tournament)
      }
      let(:team_fight_id){team_fight.id}

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(tournament.id)
        end
        it "should respond with 204 status" do
          action
          expect(response.status).to eq(204)
        end

        it "should not be able to find deleted team fight" do
          action
          expect(TeamFight.find_by_id(team_fight.id)).to be_nil
        end

        it "should destroy all points of fights of this fight" do
          action
          expect(Fight.exists?(team_fight_id: team_fight_id)).to be false
        end
      end

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
        it "should not delete the fight" do
          action
          expect(TeamFight.exists?(team_fight.id)).to be true
        end
      end
    end

    context "when the team fight doesn't exist" do
      let(:team_fight_id) {-9999}

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
      end

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(tournament.id)
        end
        it "should respond with not found status" do
          action
          expect(response).to have_http_status :not_found
        end
      end
    end
  end
end
