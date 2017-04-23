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
    let(:club_list) {
      FactoryGirl::create_list(:club,3)
    }
    before do
      club_list
      get :index, params: {format: :json}
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

      it "should return apripriate number of results" do
        expect(results.size).to eq(Club.all.size)
      end

      it "should include names of all clubs" do
        for club in club_list do
          expect(results.map(&extract_name)).to include(club.name)
        end
      end

      it "should include cities of all clubs" do
        for club in club_list do
          expect(results.map(&extract_city)).to include(club.city)
        end
      end

      it "should include descriptions of all clubs" do
        for club in club_list do
          expect(results.map(&extract_description)).to include(club.description)
        end
      end
    end
  end

  describe "show" do
    before do
      get :show, params: {format: :json,id: club_id}
    end

    subject(:results) {JSON.parse(response.body)}

    context "when the club exists" do
      let(:club) {
        FactoryGirl::create(:club)
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
    put :update, params: {format: :json, id: club_id, club: club}
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
    delete :destroy, params: {format: :json, id: club_id}
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
        post :create, params: {format: :json, club: attributes}
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

  describe "GET: admins" do
    let(:club) {
      FactoryGirl::create(:club)
    }
    let(:action) {
      get :admins, params: {format: :json, id: club.id}
    }

    before do
      user_not_admin_list = FactoryGirl::create_list(:user,2)
      club_admin_list = FactoryGirl::create_list(:club_admin, 3, club: club)
    end

    subject(:results) {JSON.parse(response.body)}

    context "when the user is not authenticated" do
      it "returns unauthorized status" do
        action
        expect(response).to have_http_status :unauthorized
      end

      it "returns response with no admins or users" do
        action
        expect(results["admins"]).to be nil
        expect(results["users"]).to be nil
      end
    end

    context "when the user is authenticated", authenticated: true do
      context "when the user is not authorized" do
        it "returns unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "returns response body to be empty" do
          action
          expect(response.body.empty?).to be true
        end
      end

      context "when the user is authorized" do
        before do
          authorize_user(club.id)
        end

        it "returns success status" do
          action
          expect(response).to have_http_status :ok
        end

        it "returns all current admins" do
          action
          expect(results["admins"].size).to eq(ClubAdmin.
            where(club_id: club.id).size)
        end

        it "returns all non-admin users" do
          action
          expect(results["users"].size).to eq((User.all - club.admins).size)
        end
      end
    end
  end

  describe "POST add_admin" do

    let(:club) {
      FactoryGirl::create(:club)
    }

    let(:tested_user) {
      FactoryGirl::create(:user)
    }

    let(:action) {
      post :add_admin, params:{ format: :json, id: club.id, user_id: tested_user.id}
    }

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        action
        expect(response).to have_http_status :unauthorized
      end

      it "does not change number of admins" do
        expect {
          action
        }.to_not change(ClubAdmin, :count)
      end
    end

    context "when user is authenticated", authenticated: true do
      context "when user is not authorized" do
        it "returns unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "does not change number of admins" do
          expect {
            action
          }.to_not change(ClubAdmin, :count)
        end
      end

      context "when user is authorized" do
        before do
          authorize_user(club.id)
        end

        context "when added user is not admin already" do
          it "returns OK status" do
            action
            expect(response).to have_http_status :no_content
          end

          it "adds the user to admins of given club" do
            action
            expect(ClubAdmin.where(club_id: club.id).size).to eq(2)
            expect(ClubAdmin.exists?(club_id: club.id, user_id: tested_user.id)).to be true
          end
        end

        context "when the user is already an andmin" do
          before do
            ClubAdmin.create(club_id: club.id, user_id: tested_user.id)
          end
          it "returns bad request status" do
            action
            expect(response).to have_http_status :bad_request
          end

          it "does not change admin count" do
            expect { action }.not_to change(ClubAdmin, :count)
          end
        end

      end
    end
  end

  describe "DELETE delete_admin" do
    let(:club) {
      FactoryGirl::create(:club)
    }

    let(:tested_user) {
      FactoryGirl::create(:user)
    }

    let(:action) {
      delete :delete_admin, params: {format: :json, id: club.id, user_id: tested_user.id}
    }
    context "when user is not authenticated" do
      it "returns unauthorized status" do
        action
        expect(response).to have_http_status :unauthorized
      end

      it "does not change number of admins" do
        expect {
          action
        }.to_not change(ClubAdmin, :count)
      end
    end

    context "when user is authenticated", authenticated: true do
      context "when user is not authorized" do
        it "returns unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "does not change number of admins" do
          expect {
            action
          }.to_not change(ClubAdmin, :count)
        end
      end

      context "when user is authorized" do
        before do
          authorize_user(club.id)
        end

        context "when the deleted admin is not an admin" do
          it "returns bad request status" do
            action
            expect(response).to have_http_status :bad_request
          end

          it "does not change admin count" do
            expect { action }.not_to change(ClubAdmin, :count)
          end
        end

        context "when the deleted admin is an admin" do

          context "when deleted admin is not the last" do
            before do
              ClubAdmin.create(club_id: club.id, user_id: tested_user.id)
            end

            it "returns OK status" do
              action
              expect(response).to have_http_status :no_content
            end

            it "removes the deleted admin from admins of given club" do
              action
              expect(ClubAdmin.where(club_id: club.id).size).to eq(1)
              expect(ClubAdmin.exists?(club_id: club.id, user_id: tested_user.id)).to be false
            end
          end

          context "when the deleted admin is the last admin" do
            let(:unadmin_self) {
              delete :delete_admin, params: {format: :json, id: club.id, user_id: current_user.id}
            }
            it "returns bad request status" do
              unadmin_self
              expect(response).to have_http_status :bad_request
            end

            it "does not change admin count" do
              expect { unadmin_self }.not_to change(ClubAdmin, :count)
            end
          end
        end
      end
    end
  end

  describe "GET: players" do
    let(:action) {
      get :players, params: {format: :json, id: club.id}
    }

    def extract_name
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

    def extract_id
      ->(object) {object["id"]}
    end

    subject(:results) { JSON.parse(response.body)}

    context "when list of players is requested for a club" do
      context "when the club exists" do
        let(:club) {FactoryGirl::create(:club)}
        let(:player_list) {FactoryGirl::create_list(:player, 10, club_id: club.id)}
        let(:other_player) {FactoryGirl::create(:player)}


        it "returns list of all 6 players" do
          player_list
          other_player
          action
          expect(results.size).to eq(10)
        end

        it "should return OK response" do
          player_list
          other_player
          action
          expect(response).to have_http_status :ok
        end

        it "should include name of the first player" do
          player_list
          other_player
          action
          expect(results.map(&extract_name)).to include(player_list[0].name)
        end

        it "should include surname of the second player" do
          player_list
          other_player
          action
          expect(results.map(&extract_surname)).to include(player_list[1].surname)
        end

        it "should include birthday of the third player" do
          player_list
          other_player
          action
          expect(results.map(&extract_birthday)).to include(player_list[2].birthday.to_s(:db))
        end

        it "should include rank of the fourth player" do
          player_list
          other_player
          action
          expect(results.map(&extract_rank)).to include(player_list[3].rank)
        end

        it "should include sex of the fifth player" do
          player_list
          other_player
          action
          expect(results.map(&extract_sex)).to include(player_list[4].sex)
        end

        it "should include club of the sixth player" do
          player_list
          other_player
          action
          expect(results.map(&extract_club)).to include(player_list[6].club.id)
        end

        it "should not contain player from another club" do
          player_list
          other_player
          action
          expect(results.map(&extract_id)).not_to include(other_player.id)
        end
      end
    end
  end

  describe "GET is_admin" do
    let(:club) {
      FactoryGirl::create(:club)
    }
    let(:club_id) {
      club.id
    }
    let(:action) {
      get :is_admin, params: {format: :json, id: club_id}
    }

    subject(:results){JSON.parse(response.body)}

    context "when the user is not authenticated" do
      it "returns unauthorized status" do
        action
        expect(response).to have_http_status :unauthorized
      end
    end
    context "when the user is authenticated", authenticated: true do
      context "when the user is not authorized" do
        it "returns OK status" do
          action
          expect(response).to have_http_status :ok
        end

        it "returns false" do
          action
          expect(results["is_admin"]).to be false
        end
      end

      context "when the user is authorized" do
        before do
          ClubAdmin.create(club_id: club.id, user_id: current_user.id)
        end
        it "returns OK status" do
          action
          expect(response).to have_http_status :ok
        end

        it "returns false" do
          action
          expect(results["is_admin"]).to be true
        end
      end

      context "when the club does not exist" do
        let(:club_id) { -9999}
        it "returns not_found status" do
          action
          expect(response).to have_http_status :not_found
        end
      end
    end
  end

  describe "GET where_admin" do
    let(:action) {
      get :where_admin, params: {format: :json}
    }

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

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        action
        expect(response).to have_http_status :unauthorized
      end
    end

    context "when user is authenticated", authenticated: true do
      let(:admin_club_list) {
        list = FactoryGirl::create_list(:club_with_admins, 10, creator: current_user)
        for club in list do
          ClubAdmin.create(club_id: club.id, user_id: current_user.id)
        end
        list
      }
      let(:not_admin_club_list) {
        FactoryGirl::create_list(:club_with_admins, 5)
      }

      it "returns OK status" do
        admin_club_list
        not_admin_club_list
        action
        expect(response).to have_http_status :ok
      end

      it "returns 10 results" do
        admin_club_list
        not_admin_club_list
        action
        expect(results.size).to eq(10)
      end

      it "returns all the clubs where user is an admin" do
        admin_club_list
        not_admin_club_list
        action
        for club in admin_club_list do
          expect(results.select {|a| a['id'] == club.id}).not_to be_empty
        end
      end

      it "returns none of the clubs where user is not an admin" do
        admin_club_list
        not_admin_club_list
        action
        for club in not_admin_club_list do
          expect(results.select {|a| a[:id] == club.id}).to be_empty
        end
      end

    end
  end

  describe "GET is_admin_for_any" do
    let(:action) {
      get :is_admin_for_any, params: {format: :json}
    }
    let(:club) {FactoryGirl::create(:club_with_admins)}

    subject(:results) { JSON.parse(response.body)}

    context "when user is not igned in" do
      it "returns OK status" do
        club
        action
        expect(response).to have_http_status :ok
      end

      it "returns false" do
        club
        action
        expect(results["is_admin"]).to be false
      end
    end

    context "when user is signed in", authenticated: true do
      context "when user is not an admin for any club" do
        it "returns OK status" do
          club
          action
          expect(response).to have_http_status :ok
        end

        it "returns false" do
          club
          action
          expect(results["is_admin"]).to be false
        end
      end

      context "when user is an admin for a club" do
        let(:admin){ClubAdmin.create(club_id: club.id, user_id: current_user.id)}
        it "returns OK status" do
          admin
          action
          expect(response).to have_http_status :ok
        end

        it "returns false" do
          admin
          action
          expect(results["is_admin"]).to be true
        end
      end
    end
  end
end
