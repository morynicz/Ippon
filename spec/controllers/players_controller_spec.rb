require 'spec_helper'

RSpec.describe PlayersController, type: :controller do
  render_views

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
end
