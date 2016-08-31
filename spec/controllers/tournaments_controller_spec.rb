require 'rails_helper'

RSpec.describe TournamentsController, type: :controller do
  render_views

  describe "GET show" do
    let(:action) {
      xhr :get, :show, format: :json, id: tournament_id
    }

    subject(:results) {JSON.parse(response.body)}

    context "when the tournament exists" do
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

  describe "POST: create" do
    let(:attributes){FactoryGirl::attributes_for(:tournament)}

    let(:action){
      xhr :post, :create, format: :json, tournament: attributes
    }

    context "when the user is not authenticated" do
      it "does not create a tournament" do
        expect {
          action
        }.to_not change(Tournament, :count)
      end

      it "denies access" do
        action
        expect(response).to have_http_status :unauthorized
      end
    end

    context "when the user is authenticated", authenticated: true do
      context "with invalid attributes" do

        let(:attributes) do
          {
            name: "",
            playoff_match_length: 0,
            group_match_length: 0,
            team_size: 0,
            player_age_constraint: '',
            player_age_constraint_value: '',
            player_sex_constraint: '',
            player_sex_constraint_value: '',
            player_rank_constraint: '',
            player_rank_constraint_value: ''
          }
        end

        it "does not create a tournament" do
          expect {
            action
          }.to_not change(Tournament, :count)
        end

        it "returns the correct status" do
          action
          expect(response).to have_http_status :unprocessable_entity
        end
      end
      context "with valid attributes" do
        it "creates a Tournament" do
          expect {
            action
          }.to change(Tournament, :count).by(1)
        end

        it "returns the correct status" do
          action
          expect(response).to be_successful
        end

        it "makes the creating user an admin" do
          action
          tournament = Tournament.find_by_name(attributes[:name])
          expect(TournamentAdmin.exists?(user_id: current_user.id, tournament_id: tournament.id)).to be true
          admin = TournamentAdmin.where(user_id: current_user.id, tournament_id: tournament.id).first

          expect(admin.status).to eq(:main.to_s)
        end
      end
    end
  end
end
