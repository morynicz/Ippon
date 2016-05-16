require 'spec_helper'

describe ClubsController do
  render_views

  def prepare_user(authenticated = false, authorized = false, club_id = nil)
    @request.env["devise.mapping"] = Devise.mappings[:user]

    if authenticated
      user = FactoryGirl.create(:user)
      sign_in user
      ClubAdmin.create(club_id: club_id, user_id: user.id) if authorized
    end
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

      it{expect(response.status).to eq(200)}
      it{expect(results["id"]).to eq(club.id)}
      it{expect(results["name"]).to eq(club.name)}
      it{expect(results["city"]).to eq(club.city)}
      it{expect(results["description"]).to eq(club.description)}
    end

    context "when club doesn't exist" do
      let(:club_id) {-9999}
      it{expect(response.status).to eq(404)}
    end
  end

  def prepare_create
    xhr :post, :create, format: :json, club: {
      name: "CreatedClub",
      city: "CreativeCity",
      description: "Sooo creative"
    }
  end

  describe "create" do
    context "when the user is not authenticated" do
      before do
        prepare_user
        prepare_create
      end
      puts "cre un #{User.all} "
      it{expect(response.status).to eq(401)}
    end

    context "when the user is authenticated" do
      before do
        prepare_user(true, false)
        prepare_create
      end

      puts "cre au #{User.all} "
      it {expect(response.status).to eq(201)}
      it {expect(Club.last.name).to eq("CreatedClub")}
      it {expect(Club.last.city).to eq("CreativeCity")}
      it {expect(Club.last.description).to eq("Sooo creative")}
    end
  end

  def prepare_update(club_id, club)
    xhr :put, :update, format: :json, id: club_id, club: club
  end

  describe "update" do
    let(:update_club_hash) {{
      name: "ClubUpdateYo", city: "FutureCity", description: "So up to date that in the future"
    }}
    context "when the club exists" do
      let(:club) {
        Club.create!(name: "UpdatedClub", city: "DateUpCity", description: "They are up to date")
      }

      context "when the user is authorized" do
        before do
          prepare_user(true,true,club.id)
          prepare_update(club.id, update_club_hash)
          club.reload
        end

        puts "up au #{User.all} "
        it{expect(response.status).to eq(204)}
        it{expect(club.name).to eq("ClubUpdateYo")}
        it{expect(club.city).to eq("FutureCity")}
        it{expect(club.description).to eq("So up to date that in the future")}
      end

      context "when the user isn't authorized" do
        before do
          prepare_user(true,false,club.id)
          prepare_update(club.id, update_club_hash)
          club.reload
        end

        puts "up unau #{User.all} "
        it{expect(response.status).to eq(500)}
        it{expect(club.name).to eq("UpdatedClub")}
        it{expect(club.city).to eq("DateUpCity")}
        it{expect(club.description).to eq("They are up to date")}

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
          prepare_user(true,false)
          prepare_update(club_id,update_club_hash)
        end
        puts "up noc unau #{User.all} "
        it{expect(response.status).to eq(401)}
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

      context "when the user is authorized" do
        before do
          prepare_user(true,true,club.id)
          prepare_destroy(club.id)
        end
        puts "des au #{User.all} "
        it{expect(response.status).to eq(204)}
        it{expect(Club.find_by_id(club.id)).to be_nil}
      end

      context "when the user is not authorized" do
        before do
          prepare_user(true,false)
          prepare_destroy(club.id)
        end
        puts "des unau #{User.all} "
        it{expect(response.status).to eq(500)}
        it{expect(Club.exists?(club.id)).to be true}
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
          prepare_user(true,false)
          prepare_destroy(club_id)
        end

        it{expect(response.status).to eq(500)}
      end
    end
  end
end
