require 'spec_helper'

describe ClubsController do
  render_views

  def authorize_user(club_id)
    ClubAdmin.create(club_id: club_id, user_id: current_user.id)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "index" do
    before do
      Club.create!(name: 'Ryushinkai', city: 'Wrocław', description: 'Debeściaki');
      Club.create!(name: 'Innyfajnyklub', city: 'Miastów', description: 'Mlody ale cool');
      Club.create!(name: 'NiemamPomyslu', city: 'Gdzies', description: 'HurHurHur');

      xhr :get, :index, format: :json
    end

    subject(:results) { JSON.parse(response.body)}

    def extract_name
      ->(object) { object["name"]}
    end

    def extract_city
      ->(object) {object["city"]}
    end

    def extract_description
      ->(object) {object["description"]}
    end

    context "when we want the full list" do
      it "should 200" do
        expect(response.status).to eq(200)
      end

      it "should return four results" do
        expect(results.size).to eq(3)
      end

      it "should include 'Ryushinkai' name" do
        expect(results.map(&extract_name)).to include('Ryushinkai')
      end

      it "should include 'Miastów' city" do
        expect(results.map(&extract_city)).to include('Miastów')
      end

      it "should include 'HurHurHur' description" do
        expect(results.map(&extract_description)).to include('HurHurHur')
      end
    end
  end

  describe "show" do
    before do
      xhr :get, :show, format: :json, id: club_id
    end

    subject(:results) {JSON.parse(response.body)}

    context "when the club exists" do
      let(:club) {
        Club.create!(name: "ShowingClub", city: "CityOfShows", description: "They are quite revealing")
      }
      let(:club_id){club.id}

      it "should return 200 status" do
        expect(response.status).to eq(200)
      end

      it "should return result with correct id" do
        expect(results["id"]).to eq(club.id)
      end

      it "should return result with correct name" do
        expect(results["name"]).to eq(club.name)
      end

      it "should return result with correct city" do
        expect(results["city"]).to eq(club.city)
      end

      it "should return result with correct description" do
        expect(results["description"]).to eq(club.description)
      end
    end

    context "when club doesn't exist" do
      let(:club_id) {-9999}
      it "should respond with 404 status" do
        expect(response.status).to eq(404)
      end
    end
  end

  def prepare_update(club_id, club)
    xhr :put, :update, format: :json, id: club_id, club: club
  end

  describe "update" do
    let(:update_club_attrs) {
      FactoryGirl::attributes_for(:club)
    }
    let(:club_attrs) {
      FactoryGirl::attributes_for(:club)
    }
    context "when the club exists" do
      let(:club) {
        Club.create!(club_attrs)
      }

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(club.id)
          prepare_update(club.id, update_club_attrs)
          club.reload
        end
        context "when the update atttributes are valid" do
          it "should return correct status" do
            expect(response.status).to eq(204)
          end

          it "should update club name" do
            expect(club.name).to eq(update_club_attrs[:name])
          end

          it "should update club city" do
            expect(club.city).to eq(update_club_attrs[:city])
          end

          it "should update club description" do
            expect(club.description).to eq(update_club_attrs[:description])
          end
        end

        context "when the update attributes are not valid" do
          let(:update_club_attrs) {
            {
              name: '',
              city: ''
            }
          }

          it "should not update club attributes" do
            expect(club.name).to eq(club_attrs[:name])
            expect(club.city).to eq(club_attrs[:city])
            expect(club.description).to eq(club_attrs[:description])
          end

          it "should return unporcessable entity" do
            expect(response).to have_http_status :unprocessable_entity
          end
        end
      end

      context "when the user isn't authorized" do
        before do
          prepare_update(club.id, update_club_attrs)
          club.reload
        end

        it "should respond with unauthorized status" do
          expect(response).to have_http_status :unauthorized
        end

        it "should not update club attributes" do
          expect(club.name).to eq(club_attrs[:name])
          expect(club.city).to eq(club_attrs[:city])
          expect(club.description).to eq(club_attrs[:description])
        end
      end
    end

    context "when the club doesn't exist" do
      let(:club_id) {-9999}

      #not possible due to constraint on ClubAdmins
      # context "when the user is authorized" do
      #   before do
      #     prepare_user(true,true, club_id)
      #     prepare_update(club_id,update_club_hash)
      #   end
      #
      #   it{expect(response.status).to eq(404)}
      # end

      context "when user is not authorized" do
        before do
          prepare_update(club_id,update_club_attrs)
        end
        it "should respond with unauthorized status" do
          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end

  def prepare_destroy(club_id)
    xhr :delete, :destroy, format: :json, id: club_id
  end

  describe "destroy" do
    let(:club) {
      Club.create!(name: "End of the line club", city: "City of the end", description: "They are finished")
    }

    context "when the club exists" do

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(club.id)
          prepare_destroy(club.id)
        end
        it "should respond with 204 status" do
          expect(response.status).to eq(204)
        end
        it "should not be able to find deleted club" do
          expect(Club.find_by_id(club.id)).to be_nil
        end
      end

      context "when the user is not authorized" do
        before do
          prepare_destroy(club.id)
        end
        it "should respond with unauthorized status" do
          expect(response).to have_http_status :unauthorized
        end
        it "should not delete the club" do
          expect(Club.exists?(club.id)).to be true
        end
      end
    end

    context "when the club doesn't exist" do
      let(:club_id) {-9999}
      ## Not possible due to ClubAdmins constraints
      # context "when the user is authorized" do
      #   before do
      #     prepare_user(true,true,club_id)
      #     prepare_destroy(club_id)
      #   end
      #
      #   it{expect(response.status).to eq(404)}
      # end

      context "when the user is not authorized" do
        before do
          prepare_destroy(club_id)
        end

        it "should respond with unauthorized status" do
          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end

  describe "POST :create" do
    let(:attributes) {  FactoryGirl.attributes_for(:club) }
    let(:action) do
        xhr :post, :create, format: :json, club: attributes
    end

    context "when the user is not authenticated" do
      it "does not create a club" do
        expect {
          action
        }.to_not change(Club, :count)
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
             name: '',
             city: ''
          }
        end

        it "does not create a club" do
          expect {
            action
          }.to_not change(Club, :count)
        end

        it "returns the correct status" do
          action
          expect(response).to have_http_status :unprocessable_entity
        end
      end
      context "with valid attributes" do
        it "creates a club" do
          expect {
            action
          }.to change(Club, :count).by(1)
        end

        it "returns the correct status" do
          action
          expect(response).to be_successful
        end
      end
    end
  end
end
