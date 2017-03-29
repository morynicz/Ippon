require 'rails_helper'

RSpec.describe GroupFight, type: :model do
    describe "destroy" do
      context "when the group fight is destroyed" do
        let(:group_fight) { FactoryGirl::create(:group_fight)}
        it "deletes it's team fight" do
          team_fight_id = group_fight.team_fight.id
          group_fight.destroy

          expect(TeamFight.exists?(team_fight_id)).to be false
        end
      end
    end
end
