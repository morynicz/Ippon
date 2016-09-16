require 'rails_helper'

RSpec.describe FightsController, type: :controller do
  render_views

  def extract_id
    ->(object) { object["id"]}
  end

  def extract_type
    ->(object) {object["type"]}
  end

  def extract_player_id
    ->(object) {object["player_id"]}
  end

  def authorize_user(tournament_id)
    TournamentAdmin.create(tournament_id: tournament_id,
      user_id: current_user.id, status: :main)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def compare_hash_with_player(hash, player)
    expect(hash["id"]).to eq(player.id)
    expect(hash["name"]).to eq(player.name)
    expect(hash["name"]).to eq(player.name)
    expect(hash["birthday"]).to eq(player.birthday.to_s(:db))
    expect(hash["rank"]).to eq(player.rank)
    expect(hash["sex"]).to eq(player.sex)
  end

  def compare_hash_with_fight(hash, fight)
    expect(hash["state"]).to eq(fight.state)
    expect(hash["shiro_id"]).to eq(fight.shiro_id)
    expect(hash["aka_id"]).to eq(fight.aka_id)
    expect(hash["team_fight_id"]).to eq(fight.team_fight_id)
  end

  describe "GET show" do
    let(:action) {
      xhr :get, :show, format: :json, id: fight_id
    }

    subject(:results) {JSON.parse(response.body)}

    context "when the team exists" do
      let(:fight) {
        FactoryGirl::create(:fight_with_points, points_count: 2)
      }
      let(:fight_id){fight.id}

      it "should return 200 status" do
        action
        expect(response.status).to eq(200)
      end

      it "should return result with correct id" do
        action
        expect(results["fight"]["id"]).to eq(fight.id)
      end

      it "should return result with correct state" do
        action
        expect(results["fight"]["state"]).to eq(fight.state)
      end

      it "should return result with correct shiro player" do
        action
        expect(results["fight"]["shiro_id"]).to eq(fight.shiro_id)
      end

      it "should return result with correct aka player" do
        action
        expect(results["fight"]["aka_id"]).to eq(fight.aka_id)
      end

      it "should return result with correct team fight id" do
        action
        expect(results["fight"]["team_fight_id"]).to eq(fight.team_fight_id)
      end

      it "should return points with proper values" do
        action
        for point in fight.points do
          expect(results["points"].map(&extract_id)).to include(point.id)
          expect(results["points"].map(&extract_type)).to include(point.type)
          expect(results["points"].map(&extract_player_id)).
            to include(point.player_id)
        end
      end

      it "should return properly both players" do
        action
        compare_hash_with_player(results["shiro"], fight.shiro)
        compare_hash_with_player(results["aka"], fight.aka)
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
            authorize_user(fight.tournament.id)
            action
            expect(results["is_admin"]).to be true
          end
        end
      end
    end

    context "when fight doesn't exist" do
      let(:fight_id) {-9999}
      it "should respond with 404 status" do
        action
        expect(response.status).to eq(404)
      end
    end
  end

  describe "POST :create" do
    let(:team_fight) { FactoryGirl::create(:team_fight)}
    let(:attributes) { attributes_with_foreign_keys(:fight,
       team_fight_id: team_fight.id)}
    let(:action) do
        xhr :post, :create, format: :json, fight: attributes
    end

    context "when the user is not authenticated" do
      it "does not create a fight" do
        expect {
          action
        }.to_not change(Fight, :count)
      end

      it "denies access" do
        action
        expect(response).to have_http_status :unauthorized
      end
    end

    context "when the user is authenticated", authenticated: true do
      context "when user is authorized" do
        before do
          authorize_user(team_fight.tournament.id)
        end

        context "with invalid attributes" do

          let(:attributes) do
            {
              team_fight_id: '',
              aka_id: '',
              shiro_id: '',
              state: ''
            }
          end

          it "does not create a fight" do
            expect {
              action
            }.to_not change(Fight, :count)
          end

          it "returns the correct status" do
            action
            expect(response).to have_http_status :unprocessable_entity
          end
        end

        context "with valid attributes" do
          it "creates a fight" do
            expect {
              action
            }.to change(Fight, :count).by(1)
          end

          it "returns the correct status" do
            action
            expect(response).to be_successful
          end

          it "creates a fight with proper values" do
            action
            f = Fight.last
            compare_hash_with_fight(attributes, f)
          end
        end
      end

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "does not create a fight" do
          expect {
            action
          }.to_not change(Fight, :count)
        end
      end
    end
  end

  describe "PATCH update" do
    let(:team_fight) {
      FactoryGirl::create(:team_fight)
    }

    let(:action) {
      xhr :put, :update, format: :json, id: fight.id, fight: update_attrs
      fight.reload
    }

    let(:update_attrs) {
        attributes_with_foreign_keys(:fight, team_fight_id: team_fight.id)
    }
    let(:attrs) {
      attributes_with_foreign_keys(:fight, team_fight_id: team_fight.id)
    }
    context "when the fight exists" do
      let(:fight) {
        Fight.create(attrs)
      }

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(team_fight.tournament.id)
        end
        context "when the update atttributes are valid" do
          it "should return correct status" do
            action
            expect(response.status).to eq(204)
          end

          it "should update fight attributes" do
            action
            compare_hash_with_fight(update_attrs, fight)
          end
        end

        context "when the update attributes are not valid" do
          let(:update_attrs) {
            {
              team_fight_id: '',
              aka_id: '',
              shiro_id: '',
              state: ''
            }
          }

          it "should not update team attributes" do
            action
            compare_hash_with_fight(attrs, fight)
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

        it "should not update team attributes" do
          action
          compare_hash_with_fight(attrs, fight)
        end
      end
    end

    context "when the team doesn't exist" do
      let(:fight_id) {-9999}

      let(:action) {
        xhr :put, :update, format: :json, id: fight_id, team: update_attrs
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
    let(:team_fight) {
      FactoryGirl::create(:team_fight)
    }

    let(:action) {
        xhr :delete, :destroy, format: :json, id: fight_id
    }

    context "when the fight exists" do
      let(:fight) {
        FactoryGirl::create(:fight_with_points, team_fight_id: team_fight.id)
      }
      let(:fight_id){fight.id}

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(team_fight.tournament.id)
        end
        it "should respond with 204 status" do
          action
          expect(response.status).to eq(204)
        end

        it "should not be able to find deleted fight" do
          action
          expect(Fight.find_by_id(fight.id)).to be_nil
        end

        it "should destroy all points of this fight" do
          action
          expect(Point.exists?(fight_id: fight_id)).to be false
        end
      end

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
        it "should not delete the fight" do
          action
          expect(Fight.exists?(fight.id)).to be true
        end
      end
    end

    context "when the fight doesn't exist" do
      let(:fight_id) {-9999}

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
      end

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(team_fight.tournament.id)
        end
        it "should respond with not found status" do
          action
          expect(response).to have_http_status :not_found
        end
      end
    end
  end
end
