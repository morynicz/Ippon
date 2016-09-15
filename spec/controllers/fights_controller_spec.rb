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
    TournamentAdmin.create(tournament_id: tournament_id, user_id: current_user.id, status: :main)
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
          expect(results["points"].map(&extract_player_id)).to include(point.player_id)
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


end
