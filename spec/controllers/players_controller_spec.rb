require 'spec_helper'

RSpec.describe PlayersController, type: :controller do
  render_views

  def authorize_user(club_id)
    ClubAdmin.create(club_id: club_id, user_id: current_user.id)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET index" do
    let(:player_list) {
      FactoryGirl::create_list(:player,10)
    }

    before do
      player_list
      xhr :get, :index, format: :json
    end

    subject(:results) { JSON.parse(response.body)}

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



    context "when we want the full list" do
      it "should 200" do
        expect(response.status).to eq(200)
      end

      it "should return ten results" do
        expect(results.size).to eq(10)
      end

      it "should include name of the first player" do
        expect(results.map(&extract_name)).to include(player_list[0].name)
      end

      it "should include surname of the second player" do
        expect(results.map(&extract_surname)).to include(player_list[1].surname)
      end

      it "should include birthday of the third player" do
        expect(results.map(&extract_birthday)).to include(player_list[2].birthday.to_s(:db))
      end

      it "should include rank of the fourth player" do
        expect(results.map(&extract_rank)).to include(player_list[3].rank)
      end

      it "should include sex of the fifth player" do
        expect(results.map(&extract_sex)).to include(player_list[4].sex)
      end

      it "should include club of the sixth player" do
        expect(results.map(&extract_club)).to include(player_list[6].club.id)
      end
    end
  end

  describe "GET show" do
    let(:action) {
      xhr :get, :show, format: :json, id: player_id
    }

    subject(:results) {JSON.parse(response.body)}

    context "when the player exists" do
      let(:player) {
        FactoryGirl::create(:player)
      }
      let(:player_id){player.id}

      it "should return 200 status" do
        action
        expect(response.status).to eq(200)
      end

      it "should return result with correct id" do
        action
        expect(results["id"]).to eq(player.id)
      end

      it "should return result with correct name" do
        action
        expect(results["name"]).to eq(player.name)
      end

      it "should return result with correct surname" do
        action
        expect(results["surname"]).to eq(player.surname)
      end

      it "should return result with correct birthday" do
        action
        expect(results["birthday"]).to eq(player.birthday.to_s(:db))
      end

      it "should return result with correct rank" do
        action
        expect(results["rank"]).to eq(player.rank)
      end

      it "should return result with correct" do
        action
        expect(results["sex"]).to eq(player.sex)
      end
    end

    context "when player doesn't exist" do
      let(:player_id) {-9999}
      it "should respond with 404 status" do
        action
        expect(response.status).to eq(404)
      end
    end
  end

  describe "PATCH update" do
    let(:club) {
      FactoryGirl::create(:club)
    }


    let(:action) {
      xhr :put, :update, format: :json, id: player.id, player: update_player_attrs
      player.reload
    }

    let(:update_player_attrs) {
      FactoryGirl::attributes_for(:player)
    }
    let(:player_attrs) {
      FactoryGirl::attributes_for(:player, club_id: club.id)
    }
    context "when the player exists" do
      let(:player) {
        Player.create(player_attrs)
      }

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(club.id)
        end
        context "when the update atttributes are valid" do
          it "should return correct status" do
            action
            expect(response.status).to eq(204)
          end

          it "should update player name" do
            action
            expect(player.name).to eq(update_player_attrs[:name])
          end

          it "should update player birthday" do
            action
            expect(player.birthday).to eq(update_player_attrs[:birthday])
          end

          it "should update player rank" do
            action
            expect(Player.ranks[player.rank]).to eq(update_player_attrs[:rank])
          end

          it "should update player surname" do
            action
            expect(player.surname).to eq(update_player_attrs[:surname])
          end

          it "should update player sex" do
            action
            expect(Player.sexes[player.sex]).to eq(update_player_attrs[:sex])
          end

          it "should update player club id" do
            action
            expect(player.club.id).to eq(update_player_attrs[:club_id])
          end
        end

        context "when the update attributes are not valid" do
          let(:update_player_attrs) {
            {
              name: '',
              surname: '',
              birthday: '',
              rank: '',
              sex: '',
              club_id: ''
            }
          }

          it "should not update player attributes" do
            action
            expect(player.name).to eq(player_attrs[:name])
            expect(player.surname).to eq(player_attrs[:surname])
            expect(player.birthday).to eq(player_attrs[:birthday])
            expect(Player.sexes[player.sex]).to eq(player_attrs[:sex])
            expect(Player.ranks[player.rank]).to eq(player_attrs[:rank])
            expect(player.club.id).to eq(player_attrs[:club_id])
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

        it "should not update player attributes" do
          action
          expect(player.name).to eq(player_attrs[:name])
          expect(player.surname).to eq(player_attrs[:surname])
          expect(player.birthday).to eq(player_attrs[:birthday])
          expect(Player.sexes[player.sex]).to eq(player_attrs[:sex])
          expect(Player.ranks[player.rank]).to eq(player_attrs[:rank])
          expect(player.club.id).to eq(player_attrs[:club_id])
        end
      end
    end

    context "when the player doesn't exist" do
      let(:player_id) {-9999}

      let(:action) {
        xhr :put, :update, format: :json, id: player_id, player: update_player_attrs
      }

      context "when user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end

  describe "POST :create" do
    let(:club) {
      FactoryGirl::create(:club)
    }

    let(:attributes) {  FactoryGirl.attributes_for(:player, club_id: club.id) }
    let(:action) do
        xhr :post, :create, format: :json, player: attributes
    end

    context "when the user is not authenticated" do
      it "does not create a player" do
        expect {
          action
        }.to_not change(Player, :count)
      end

      it "denies access" do
        action
        expect(response).to have_http_status :unauthorized
      end
    end

    context "when the user is authenticated", authenticated: true do
      context "when user is authorized" do
        before do
          authorize_user(club.id)
        end

        context "with invalid attributes" do

          let(:attributes) do
            {
              name: '',
              surname: '',
              birthday: '',
              rank: '',
              sex: ''
            }
          end

          it "does not create a player" do
            expect {
              action
            }.to_not change(Player, :count)
          end

          it "returns the correct status" do
            action
            expect(response).to have_http_status :unprocessable_entity
          end
        end
        context "with valid attributes" do
          it "creates a player" do
            expect {
              action
            }.to change(Player, :count).by(1)
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
          }.to_not change(Player, :count)
        end
      end
    end
  end
end
