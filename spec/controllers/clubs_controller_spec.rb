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
end
