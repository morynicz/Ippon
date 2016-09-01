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

      it "should return result with tournament size" do
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

  describe "index" do
    let(:tournament_list) {
      FactoryGirl::create_list(:tournament,3)
    }
    before do
      tournament_list
      xhr :get, :index, format: :json
    end

    subject(:results) { JSON.parse(response.body)}

    def extract_name
      ->(object) { object["name"]}
    end

    def extract_playoff_match_length
      ->(object) {object["playoff_match_length"]}
    end

    def extract_group_match_length
      ->(object) {object["group_match_length"]}
    end

    def extract_team_size
      ->(object) {object["team_size"]}
    end

    def extract_player_age_constraint
      ->(object) {object["player_age_constraint"]}
    end

    def extract_player_age_constraint_value
      ->(object) {object["player_age_constraint_value"]}
    end

    def extract_player_rank_constraint
      ->(object) {object["player_rank_constraint"]}
    end

    def extract_player_rank_constraint_value
      ->(object) {object["player_rank_constraint_value"]}
    end

    def extract_player_sex_constraint
      ->(object) {object["player_sex_constraint"]}
    end

    def extract_player_sex_constraint_value
      ->(object) {object["player_sex_constraint_value"]}
    end


    context "when we want the full list" do
      it "should 200" do
        expect(response.status).to eq(200)
      end

      it "should return three results" do
        expect(results.size).to eq(3)
      end

      it "should include all the values of all the tournaments" do
        for tournament in tournament_list do
          expect(results.map(&extract_name)).to include(tournament.name)
          expect(results.map(&extract_group_match_length)).to include(tournament.group_match_length)
          expect(results.map(&extract_playoff_match_length)).to include(tournament.playoff_match_length)
          expect(results.map(&extract_team_size)).to include(tournament.team_size)
          expect(results.map(&extract_player_age_constraint)).to include(tournament.player_age_constraint)
          expect(results.map(&extract_player_age_constraint_value)).to include(tournament.player_age_constraint_value)
          expect(results.map(&extract_player_rank_constraint)).to include(tournament.player_rank_constraint)
          expect(results.map(&extract_player_rank_constraint_value)).to include(tournament.player_rank_constraint_value)
          expect(results.map(&extract_player_sex_constraint)).to include(tournament.player_sex_constraint)
          expect(results.map(&extract_player_sex_constraint_value)).to include(tournament.player_sex_constraint_value)
        end
      end
    end
  end
end
