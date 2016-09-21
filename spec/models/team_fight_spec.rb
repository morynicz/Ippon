require 'rails_helper'

RSpec.describe TeamFight, type: :model do
  describe "aka and shiro score" do
    let(:tournament){FactoryGirl::create(:tournament, team_size: 3)}
    let(:team_fight){
      FactoryGirl::create(:team_fight_with_fights_and_points,
        tournament: tournament, aka_points: 5, shiro_points: 3)}

    context "when aka_score called" do
      it "returns 5 points for aka" do
        expect(team_fight.aka_score).to eq(5)
      end
    end

    context "when shiro_score called" do
      it "returns 3 points for shiro" do
        expect(team_fight.shiro_score).to eq(3)
      end
    end

  end

end
