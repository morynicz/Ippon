require 'rails_helper'

RSpec.describe Fight, type: :model do
  describe "player_score" do
    let(:fight) {
      f = FactoryGirl::create(:fight)
      FactoryGirl::create(:point, fight: f, player: f.aka, type: :kote)
      FactoryGirl::create(:point, fight: f, player: f.aka, type: :hansoku)

      FactoryGirl::create(:point, fight: f, player: f.shiro, type: :tsuki)
      FactoryGirl::create(:point, fight: f, player: f.shiro, type: :do)
      return f
    }

    context "when called" do
      it "returns correct score for shiro player (KOTE + HANSOKU)" do
        expect(fight.shiro_score).to eq(Point::HIT_VALUE +
          Point::HANSOKU_VALUE)
      end

      it "returns correct score for aka player (DO + TSUKI)" do
        expect(fight.aka_score).to eq(Point::HIT_VALUE * 2)
      end
    end

  end
end
