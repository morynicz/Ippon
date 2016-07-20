require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  render_views

  def extract_player_name
    ->(object) { object["name"]}
  end

  def extract_surname
    ->(object) {object["surname"]}
  end

  def extract_birthday
    ->(object) {object["birthday"]}
  end

  def extract_rank
    ->(object) {object["rank"]}
  end

  def extract_sex
    ->(object) {object["sex"]}
  end

  def extract_club
    ->(object) {object["club_id"]}
  end

  def authorize_user(tournament_id)
    TournamentAdmin.create(tournament_id: tournament_id, user_id: current_user.id, status: :main)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET show" do
    let(:action) {
      xhr :get, :show, format: :json, id: team_id
    }

    subject(:results) {JSON.parse(response.body)}

    context "when the team exists" do
      let(:player_list) {
        FactoryGirl::create_list(:player,3)
      }
      let(:team) {
        FactoryGirl::create(:team, required_size: 3)
      }
      let(:team_id){team.id}

      before do
        team
        player_list
        for player in player_list do
          TeamMembership.create(player_id: player.id, team_id: team.id)
        end
      end

      it "should return 200 status" do
        action
        expect(response.status).to eq(200)
      end

      it "should return result with correct id" do
        action
        expect(results["team"]["id"]).to eq(team.id)
      end

      it "should return result with correct name" do
        action
        expect(results["team"]["name"]).to eq(team.name)
      end

      it "should return result with correct required size" do
        action
        expect(results["team"]["required_size"]).to eq(team.required_size)
      end

      it "should return players with proper values" do
        action
        for player in player_list do
          expect(results["players"].map(&extract_player_name)).to include(player.name)
          expect(results["players"].map(&extract_surname)).to include(player.surname)
          expect(results["players"].map(&extract_club)).to include(player.club_id)
        end
      end
    end

    context "when team doesn't exist" do
      let(:team_id) {-9999}
      it "should respond with 404 status" do
        action
        expect(response.status).to eq(404)
      end
    end
  end

  describe "POST :create" do
    let(:tournament) {
      FactoryGirl::create(:tournament)
    }

    let(:attributes) {  FactoryGirl.attributes_for(:team, tournament_id: tournament.id) }
    let(:action) do
        xhr :post, :create, format: :json, team: attributes
    end

    context "when the user is not authenticated" do
      it "does not create a Team" do
        expect {
          action
        }.to_not change(Team, :count)
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
              required_size: ''
            }
          end

          it "does not create a team" do
            expect {
              action
            }.to_not change(Team, :count)
          end

          it "returns the correct status" do
            action
            expect(response).to have_http_status :unprocessable_entity
          end
        end
        context "with valid attributes" do
          it "creates a team" do
            expect {
              action
            }.to change(Team, :count).by(1)
          end

          it "returns the correct status" do
            action
            expect(response).to be_successful
          end
        end
      end

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "does not create a player" do
          expect {
            action
          }.to_not change(Team, :count)
        end
      end
    end
  end

  describe "PATCH update" do
    let(:tournament) {
      FactoryGirl::create(:tournament)
    }


    let(:action) {
      xhr :put, :update, format: :json, id: team.id, team: update_team_attrs
      team.reload
    }

    let(:update_team_attrs) {
      FactoryGirl::attributes_for(:team)
    }
    let(:team_attrs) {
      FactoryGirl::attributes_for(:team, tournament_id: tournament.id)
    }
    context "when the team exists" do
      let(:team) {
        Team.create(team_attrs)
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

          it "should update team attributes" do
            action
            expect(team.name).to eq(update_team_attrs[:name])
            expect(team.required_size).to eq(update_team_attrs[:required_size])
            expect(team.tournament_id).to eq(update_team_attrs[:tournament_id])
          end
        end

        context "when the update attributes are not valid" do
          let(:update_team_attrs) {
            {
              name: '',
              required_size: '',
              tournament_id: ''
            }
          }

          it "should not update team attributes" do
            action
            expect(team.name).to eq(team_attrs[:name])
            expect(team.required_size).to eq(team_attrs[:required_size])
            expect(team.tournament_id).to eq(team_attrs[:tournament_id])
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

        it "should update team attributes" do
          action
          expect(team.name).to eq(team_attrs[:name])
          expect(team.required_size).to eq(team_attrs[:required_size])
          expect(team.tournament_id).to eq(team_attrs[:tournament_id])
        end
      end
    end

    context "when the team doesn't exist" do
      let(:team_id) {-9999}

      let(:action) {
        xhr :put, :update, format: :json, id: team_id, team: update_team_attrs
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
    let(:tournament) {
      FactoryGirl::create(:tournament)
    }

    let(:action) {
        xhr :delete, :destroy, format: :json, id: team_id
    }

    let(:player_list) {
      FactoryGirl::create_list(:player,3)
    }
    context "when the team exists" do
      let(:team) {
        team = FactoryGirl::create(:team, tournament_id: tournament.id)
        for player in player_list do
          TeamMembership.create(player_id: player.id, team_id: team.id)
        end
        team
      }
      let(:team_id){team.id}

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(tournament.id)
        end
        it "should respond with 204 status" do
          action
          expect(response.status).to eq(204)
        end

        it "should not be able to find deleted team" do
          action
          expect(Team.find_by_id(team.id)).to be_nil
        end

        it "should destroy all memberships of this team" do
          action
          expect(TeamMembership.exists?(team_id: team_id)).to be false
        end
      end

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
        it "should not delete the team" do
          action
          expect(Team.exists?(team.id)).to be true
        end
      end
    end

    context "when the team doesn't exist" do
      let(:team_id) {-9999}

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
