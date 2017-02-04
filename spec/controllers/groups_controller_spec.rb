require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  render_views

  def extract_id
    ->(object) { object["id"]}
  end

  def extract_name
    ->(object) { object["name"]}
  end

  def extract_aka_team_id
    ->(object) { object["aka_team_id"]}
  end

  def extract_shiro_team_id
    ->(object) { object["shiro_team_id"]}
  end

  def extract_tournament_id
    ->(object) { object["torunament_id"]}
  end

  def extract_group
    ->(object) { object["group"]}
  end

  def extract_teams
    ->(object) { object["teams"]}
  end

  def extract_team_fights
    ->(object) { object["team_fights"]}
  end

  def extract_state
    ->(object) {object["state"]}
  end

  def check_array_for_team_fights(result, expected)
    for team_fight in expected do
      expect(result.map(&extract_id)).to include(team_fight.id)
      expect(result.map(&extract_shiro_team_id)).to include(team_fight.shiro_team_id)
      expect(result.map(&extract_aka_team_id)).to include(team_fight.aka_team_id)
    end
  end

  def check_array_for_teams(result, expected)
    for team in expected do
      expect(result.map(&extract_name)).to include(team.name)
      expect(result.map(&extract_id)).to include(team.id)
    end
  end

  def authorize_user(tournament_id)
    TournamentAdmin.create(tournament_id: tournament_id,
      user_id: current_user.id, status: :main)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def compare_hash_with_group(hash, group)
    expect(group.name).to eq(hash["name"])
    expect(group.tournament_id).to eq(hash["tournament_id"])
  end

  describe "GET show" do
    let(:action) {
      xhr :get, :show, format: :json, id: group_id
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
        extracted_teams = results["teams"]
        check_array_for_teams(extracted_teams, group.teams)
      end

      it 'should return all team fights' do
        action
        extracted_teamfights = results["team_fights"]
        check_array_for_team_fights(extracted_teamfights, group.team_fights)
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

  describe "GET index" do
    let(:tournament) {
      FactoryGirl::create(:tournament)
    }

    let(:group_list) {
      FactoryGirl::create_list(:group_with_fights,10, tournament: tournament)
    }

    let(:action) {
      xhr :get, :index, format: :json, tournament_id: tournament.id
    }

    subject(:results) { JSON.parse(response.body)}

    context "when we want the full list" do
      it "should return 200 status" do
        group_list
        action
        expect(response.status).to eq(200)
      end

      it "should return 10 results" do
        group_list
        action
        expect(results.size).to eq(tournament.groups.size)
      end

      it "should include name and id of the group" do
        group_list
        action

        for group in group_list do
          expect(results.map(&extract_group).map(&extract_name)).to include(group.name)
          expect(results.map(&extract_group).map(&extract_id)).to include(group.id)
        end
      end

      it "should contain all the teams which are members of all groups" do
        group_list
        action

        extracted_teams = results.map(&extract_teams).flatten

        for group in group_list do
          check_array_for_teams(extracted_teams, group.teams)
        end
      end

      it "should contain all the team fights of all the groups" do
        group_list
        action

        extracted_teamfights = results.map(&extract_team_fights).flatten

        for group in group_list do
          check_array_for_team_fights(extracted_teamfights, group.team_fights)
        end
      end
    end
  end

  describe "POST :create" do
    let(:tournament) {FactoryGirl::create(:tournament)}
    let(:attributes) { attributes_with_foreign_keys(:group,
       tournament: tournament)}
    let(:action) do
        xhr :post, :create, format: :json, group: attributes, tournament_id: tournament.id
    end

    subject(:results) {JSON.parse(response.body)}

    context "when the user is not authenticated" do
      it "does not create a team fight" do
        expect {
          action
        }.to_not change(Group, :count)
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
              name: '',
              tournament_id: ''
            }
          end

          it "does not create a group" do
            expect {
              action
            }.to_not change(Group, :count)
          end

          it "returns the correct status" do
            action
            expect(response).to have_http_status :unprocessable_entity
          end
        end

        context "with valid attributes" do
          it "creates a group" do
            expect {
              action
            }.to change(Group, :count).by(1)
          end

          it "returns the correct status" do
            action
            expect(response).to be_successful
          end

          it "creates a group with proper values" do
            action
            created = Group.find(results["group"]["id"])
            compare_hash_with_group(attributes, created)
          end
        end
      end

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "does not create a group" do
          expect {
            action
          }.to_not change(Group, :count)
        end
      end
    end
  end

  describe "PATCH update" do
    let(:tournament) {FactoryGirl::create(:tournament)}

    let(:action) {
      xhr :put, :update, format: :json, id: group.id,
        group: update_attrs
      group.reload
    }

    let(:update_attrs) {
        attributes_with_foreign_keys(:group, tournament: tournament)
    }
    let(:attrs) {
      attributes_with_foreign_keys(:group, tournament: tournament)
    }
    context "when the group exists" do
      let(:group) {
        Group.create(attrs)
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

          it "should update the attributes" do
            action
            compare_hash_with_group(update_attrs, group)
          end
        end

        context "when the update attributes are not valid" do
          let(:update_attrs) do
            {
              name: '',
              tournament_id: ''
            }
          end

          it "should not update the attributes" do
            action
            compare_hash_with_group(attrs, group)
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

        it "should not update the attributes" do
          action
          compare_hash_with_group(attrs, group)
        end
      end
    end

    context "when the group doesn't exist" do
      let(:group_id) {-9999}

      let(:action) {
        xhr :put, :update, format: :json, id: group_id,
          group: update_attrs
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
        xhr :delete, :destroy, format: :json, id: group_id
    }

    context "when the group exists" do
      let(:group) {
        FactoryGirl::create(:group_with_fights,
          tournament: tournament)
      }
      let(:group_id){group.id}

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(tournament.id)
        end
        it "should respond with 204 status" do
          action
          expect(response.status).to eq(204)
        end

        it "should not be able to find deleted group" do
          action
          expect(Group.find_by_id(group.id)).to be_nil
        end

        it "should destroy all memberships of this group" do
          action
          expect(GroupMember.exists?(group_id: group_id)).to be false
        end

        it "should destroy all group fights of this group" do
          action
          expect(GroupFight.exists?(group_id: group_id)).to be false
        end

      end

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
        it "should not delete the fight" do
          action
          expect(Group.exists?(group.id)).to be true
        end
      end
    end

    context "when the group doesn't exist" do
      let(:group_id) {-9999}

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
