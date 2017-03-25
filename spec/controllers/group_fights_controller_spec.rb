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

  def expect_hash_eq_group_fight(hash, group_fight)
    expect(group_fight.group_id).to eq(hash[:group_id])
    expect(group_fight.team_fight_id).to eq(hash[:team_fight_id])
  end

  def get_resource_id_from_results(results)
    results["group_fight"]["id"]
  end

  def expect_hash_eq_resource(hash, group_fight)
    expect_hash_eq_group_fight(hash, group_fight)
  end


  it_behaves_like "tournament_createable" do
    let(:tournament) { FactoryGirl::create(:tournament) }
    let(:group) { FactoryGirl::create(:group, tournament: tournament) }
    let(:team_fight) { FactoryGirl::create(:team_fight, tournament: tournament)}
    let(:attributes) { FactoryGirl::attributes_for(:group_fight,
      team_fight_id: team_fight.id, group_id: group.id)}

    let(:action) do
      xhr :post, :create, format: :json, group_fight: attributes,
      group_id: group.id
    end

    let(:bad_attributes) do
      {
        group_id: '',
        team_fight_id: '',
      }
    end
    let(:resource_class) { GroupFight }
  end

  it_behaves_like "tournament_deletable" do
    let(:tournament) { FactoryGirl::create(:tournament)}
    let(:group) {FactoryGirl::create(:group, tournament: tournament)}
    let(:resource) { FactoryGirl::create(:group_fight, group: group)}
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

describe "POST :create" do
    let(:tournament) {FactoryGirl::create(:tournament)}
    let(:group) {
      FactoryGirl::create(:group, tournament: tournament)
    }
    let(:team_fight) { FactoryGirl::create(:team_fight, tournament: tournament)}
    let(:attributes) { FactoryGirl::attributes_for(:group_fight,
       team_fight_id: team_fight.id, group_id: group.id)}

    let(:action) do
        xhr :post, :create, format: :json, group_fight: attributes,
          group_id: group.id
    end

    subject(:results) {JSON.parse(response.body)}

    context "when the user is not authenticated" do
      it "does not create a group fight" do
        expect {
          action
        }.to_not change(GroupFight, :count)
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
              group_id: '',
              team_fight_id: '',
            }
          end

          it "does not create a group fight" do
            expect {
              action
            }.to_not change(GroupFight, :count)
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
            }.to change(GroupFight, :count).by(1)
          end

          it "returns the correct status" do
            action
            response.inspect
            expect(response).to be_successful
          end

          it "creates a fight with proper values" do
            action
            gf = GroupFight.find(results["group_fight"]["id"])
            expect_hash_eq_group_fight(attributes, gf)
          end
        end
      end

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "does not create a group fight" do
          expect {
            action
          }.to_not change(GroupFight, :count)
        end
      end
    end
  end

  describe "PATCH update" do
    let(:tournament) {FactoryGirl::create(:tournament)}
    let(:group) {
      FactoryGirl::create(:group, tournament: tournament)
    }
    let(:team_fight) { FactoryGirl::create(:team_fight, tournament: tournament)}
    let(:update_team_fight) { FactoryGirl::create(:team_fight, tournament: tournament)}
    let(:attributes) { FactoryGirl::attributes_for(:group_fight,
       team_fight_id: team_fight.id, group_id: group.id)}

    let(:action) {
      xhr :put, :update, format: :json, id: group_fight.id,
        group_fight: update_attrs
      group_fight.reload
    }

    let(:update_attrs) {
      FactoryGirl::attributes_for(:group_fight,
         team_fight_id: team_fight.id, group_id: group.id)
    }
    let(:attrs) {
      FactoryGirl::attributes_for(:group_fight,
         team_fight_id: update_team_fight.id, group_id: group.id)
    }
    context "when the group fight exists" do
      let(:group_fight) {
        GroupFight.create(attrs)
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

          it "should update group fight attributes" do
            action
            expect_hash_eq_group_fight(update_attrs, group_fight)
          end
        end

        context "when the update attributes are not valid" do
          let(:update_attrs) {
            {
              group_id: '',
              team_fight_id: ''
            }
          }

          it "should not update group fight attributes" do
            action
            expect_hash_eq_group_fight(attrs, group_fight)
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

        it "should not update group fight attributes" do
          action
          expect_hash_eq_group_fight(attrs, group_fight)
        end
      end
    end

    context "when the group fight doesn't exist" do
      let(:group_fight_id) {-9999}

      let(:action) {
        xhr :put, :update, format: :json, id: group_fight_id, group_fight: update_attrs
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
    let(:group) {
      FactoryGirl::create(:group, tournament: tournament)
    }
    let(:group_fight) { FactoryGirl::create(:group_fight, group: group)}

    let(:action) {
        xhr :delete, :destroy, format: :json, id: group_fight_id
    }
    let(:group_fight_id){group_fight.id}
    let(:team_fight_id){group_fight.team_fight.id}

    context "when the group fight exists" do

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(tournament.id)
        end
        it "should respond with 204 status" do
          action
          expect(response.status).to eq(204)
        end

        it "should delete group fight" do
          action
          expect(GroupFight.find_by_id(group_fight.id)).to be_nil
        end

        it "should destroy all fights of this group fight" do
          action
          expect(TeamFight.exists?(id: team_fight_id)).to be false
        end
      end

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
        it "should not delete the fight" do
          action
          expect(GroupFight.exists?(group_fight.id)).to be true
        end
      end
    end

    context "when the group fight doesn't exist" do
      let(:group_fight_id) {-9999}

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
