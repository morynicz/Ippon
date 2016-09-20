require 'rails_helper'

RSpec.describe PointsController, type: :controller do
  render_views

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def authorize_user(tournament_id)
    TournamentAdmin.create(tournament_id: tournament_id,
      user_id: current_user.id, status: :main)
  end

  describe "POST :create" do
    let(:fight) { FactoryGirl::create(:fight)}
    let(:attributes) { attributes_with_foreign_keys(:point,
       fight_id: fight.id)}
    let(:action) do
        xhr :post, :create, format: :json, point: attributes
    end

    subject(:results) {JSON.parse(response.body)}

    context "when the user is not authenticated" do
      it "does not create a point" do
        expect {
          action
        }.to_not change(Point, :count)
      end

      it "denies access" do
        action
        expect(response).to have_http_status :unauthorized
      end
    end

    context "when the user is authenticated", authenticated: true do
      context "when user is authorized" do
        before do
          authorize_user(fight.tournament.id)
        end

        context "with invalid attributes" do

          let(:attributes) do
            {
              type: '',
              player_id: '',
              state: ''
            }
          end

          it "does not create a point" do
            expect {
              action
            }.to_not change(Point, :count)
          end

          it "returns the correct status" do
            action
            expect(response).to have_http_status :unprocessable_entity
          end
        end

        context "with valid attributes" do
          it "creates a point" do
            expect {
              action
            }.to change(Point, :count).by(1)
          end

          it "returns the correct status" do
            action
            expect(response).to be_successful
          end

          it "creates a point with proper values" do
            action
            pt = Point.find(results["id"])
            expect(pt.player_id).to eq(attributes["player_id"])
            expect(pt.fight_id).to eq(attributes["fight_id"])
            expect(pt.type).to eq(attributes["type"])
          end
        end
      end

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "does not create a point" do
          expect {
            action
          }.to_not change(Point, :count)
        end
      end
    end
  end

  describe "GET show" do
    let(:action) {
      xhr :get, :show, format: :json, id: point_id
    }

    subject(:results) {JSON.parse(response.body)}

    context "when the point exists" do
      let(:point) {
        FactoryGirl::create(:point)
      }
      let(:point_id){point.id}

      it "should return 200 status" do
        action
        expect(response.status).to eq(200)
      end

      it "should return result with correct id" do
        action
        expect(results["id"]).to eq(point.id)
      end

      it "should return result with correct type" do
        action
        expect(results["type"]).to eq(point.type)
      end

      it "should return result with correct player" do
        action
        expect(results["player_id"]).to eq(point.player_id)
      end

      it "should return result with correct fight id" do
        action
        expect(results["fight_id"]).to eq(point.fight_id)
      end
    end

    context "when point doesn't exist" do
      let(:point_id) {-9999}
      it "should respond with 404 status" do
        action
        expect(response.status).to eq(404)
      end
    end
  end
end
