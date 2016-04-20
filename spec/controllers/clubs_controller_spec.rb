require 'spec_helper'

describe ClubsController do
  render_views
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

  describe "create" do
    before do
      xhr :post, :create, format: :json, club: {
        name: "CreatedClub",
        city: "CreativeCity",
        description: "Sooo creative"
      }
      end

      it {expect(response.status).to eq(201)}
      it {expect(Club.last.name).to eq("CreatedClub")}
      it {expect(Club.last.city).to eq("CreativeCity")}
      it {expect(Club.last.description).to eq("Sooo creative")}
  end

  describe "update" do
    context "when the club exists" do
      let(:club) {
        Club.create!(name: "UpdatedClub", city: "DateUpCity", description: "They are up to date")
      }

      before do
        xhr :put, :update, format: :json, id: club.id, club: {
          name: "ClubUpdateYo", city: "FutureCity", description: "So up to date that in the future"
        }
        club.reload
      end

      it{expect(response.status).to eq(204)}
      it{expect(club.name).to eq("ClubUpdateYo")}
      it{expect(club.city).to eq("FutureCity")}
      it{expect(club.description).to eq("So up to date that in the future")}
    end

    context "when the club doesn't exist" do
      before do
        xhr :put, :update, format: :json, id: club_id, club: {
          name: "ClubUpdateYo", city: "FutureCity", description: "So up to date that in the future"
        }
      end

      let(:club_id) {-9999}
      it{expect(response.status).to eq(404)}
    end

  end

  describe "destroy" do
    before do
      xhr :delete, :destroy, format: :json, id: club_id
    end

    context "when the club exists" do
      let(:club_id) {
        Club.create!(name: "End of the line club", city: "City of the end", description: "They are finished")
      }

      it{expect(response.status).to eq(204)}
      it{expect(Club.find_by_id(club_id)).to be_nil}
    end

    context "when the club doesn't exist" do
      let(:club_id) {-9999}
      it{expect(response.status).to eq(404)}
    end
  end
end
