require 'rails_helper'

RSpec.describe PlayoffFightsController, type: :controller do
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

    def extract_playoff_fight
      ->(object) {object["playoff_fight"]}
    end

    def expect_hash_include_team_fight(hash,  team_fight)
      expect(hash.map(&extract_id)).to include(team_fight.id)
      expect(hash.map(&extract_state)).to include(team_fight.state)
      expect(hash.map(&extract_shiro_team_id)).to include(team_fight.shiro_team_id)
      expect(hash.map(&extract_aka_team_id)).to include(team_fight.aka_team_id)
    end

    def expect_hash_eq_playoff_fight(hash, playoff_fight)
      expect(playoff_fight.previous_aka_fight_id).to eq(hash[:previous_aka_fight_id])
      expect(playoff_fight.previous_shiro_fight_id).to eq(hash[:previous_shiro_fight_id])
      expect(playoff_fight.team_fight_id).to eq(hash[:team_fight_id])
      expect(playoff_fight.tournament_id).to eq(hash[:tournament_id])
    end

    def get_resource_from_results(results)
      results["group_id"]
    end

    def get_resource_id_from_results(results)
      results["playoff_fight"]["id"]
    end

    def expect_hash_eq_resource(hash, group_fight)
      expect_hash_eq_playoff_fight(hash, group_fight)
    end

    def expect_result_with_correct_resource(result, playoff_fight)
      expect(results["playoff_fight"]["previous_aka_fight_id"]).to eq(playoff_fight.previous_aka_fight_id)
      expect(results["playoff_fight"]["previous_shiro_fight_id"]).to eq(playoff_fight.previous_shiro_fight_id)
      expect(results["playoff_fight"]["team_fight_id"]).to eq(playoff_fight.team_fight_id)
      expect(results["playoff_fight"]["tournament_id"]).to eq(playoff_fight.tournament_id)
      expect_hash_eq_teamfight(results["team_fight"], playoff_fight.team_fight)
    end

    it_behaves_like "tournament_createable" do
      let(:tournament) { FactoryGirl::create(:tournament) }
      let(:team_fight) { FactoryGirl::create(:team_fight, tournament: tournament)}
      let(:previous_aka_fight) { FactoryGirl::create(:playoff_fight, tournament: tournament) }
      let(:previous_shiro_fight) { FactoryGirl::create(:playoff_fight, tournament: tournament) }

      let(:attributes) { FactoryGirl::attributes_for(:playoff_fight,
                                                    team_fight_id: team_fight.id,
                                                    tournament_id: tournament.id,
                                                    previous_aka_fight_id: previous_aka_fight.id,
                                                    previous_shiro_fight_id: previous_shiro_fight.id)}

      let(:action) do
        xhr :post, :create, format: :json, playoff_fight: attributes,
        tournament_id: tournament.id
      end

      let(:bad_attributes) {
        {
          tournament_id: '',
        }
      }
      let(:resource_class) { PlayoffFight }
    end

    it_behaves_like "tournament_showable" do
      let(:action) { xhr :get, :show, format: :json, id: resource_id }
      let(:tournament) { FactoryGirl::create(:tournament) }
      let(:resource) { FactoryGirl::create(:playoff_fight, tournament: tournament) }
    end

    it_behaves_like "tournament_updateable" do
      let(:tournament) {FactoryGirl::create(:tournament)}
      let(:team_fight) { FactoryGirl::create(:team_fight, tournament: tournament)}
      let(:update_team_fight) { FactoryGirl::create(:team_fight, tournament: tournament)}
      let(:attributes) { FactoryGirl::attributes_for(:playoff_fight,
         team_fight_id: team_fight.id, tournament_id: tournament.id)}
      let(:update_attrs) { FactoryGirl::attributes_for(:playoff_fight,
          team_fight_id: team_fight.id, tournament_id: tournament.id)
      }

      let(:action) {
        xhr :put, :update, format: :json, id: resource_id,
          playoff_fight: update_attrs
      }

      let(:attrs) {
        FactoryGirl::attributes_for(:playoff_fight,
           team_fight_id: update_team_fight.id, tournament_id: tournament.id)
      }
      let(:bad_attributes) {
        {
          tournament_id: '',
        }
      }
      let(:resource_class){PlayoffFight}
    end

    it_behaves_like "tournament_deletable" do
      let(:tournament) { FactoryGirl::create(:tournament)}
      let(:resource) { FactoryGirl::create(:playoff_fight, tournament: tournament)}
    end

describe "GET index" do
  let(:tournament) {
    FactoryGirl::create(:tournament)
  }

  let(:playoff_fights) {
    FactoryGirl::create_list(:playoff_fight,10, tournament: tournament)
  }

  let(:action) {
    xhr :get, :index, format: :json, tournament_id: tournament.id
  }

  subject(:results) { JSON.parse(response.body)}

  context "when we want the full list" do
    it "should return 200 status" do
      playoff_fights
      action
      expect(response.status).to eq(200)
    end

    it "should return 10 results" do
      playoff_fights
      action
      expect(results.size).to eq(tournament.playoff_fights.size)
    end

    it "should include name and ids of the group fights" do
      playoff_fights
      action

      playoff_fight_ids = results.map(&extract_playoff_fight).map(&extract_id)

      for playoff_fight in playoff_fights do
        expect(playoff_fight_ids).to include(playoff_fight.id)
      end
    end

    it "should contain all the team fights of all the group fights" do
      playoff_fights
      action

      team_fights = results.map(&extract_team_fight)

      for playoff_fight in playoff_fights do
        expect_hash_include_team_fight(team_fights, playoff_fight.team_fight)
      end
    end
  end
end
end
