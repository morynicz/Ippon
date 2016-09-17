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

          # it "creates a fight with proper values" do
          #   action
          #   f = response.body
          #   compare_hash_with_fight(attributes, f)
          # end
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
end
