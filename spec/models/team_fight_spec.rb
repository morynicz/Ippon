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

  describe "tournament" do
    let(:group_fight){FactoryGirl::create(:group_fight)}
    context "when called on fight belonging to a group" do
      it "returns the tournament it belongs to" do
        expect(group_fight.team_fight.tournament).to eq(group_fight.tournament)
      end
    end
  end

end
