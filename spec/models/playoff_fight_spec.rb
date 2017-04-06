require 'rails_helper'

RSpec.describe PlayoffFight, type: :model do
  context "when the playoff fight is deleted" do
          let(:playoff_fight) { FactoryGirl::create(:playoff_fight_with_team_fight)}
          it "deletes it's team fight" do
            team_fight_id = playoff_fight.team_fight.id
            playoff_fight.destroy

            expect(TeamFight.exists?(team_fight_id)).to be false
          end
        end
end
