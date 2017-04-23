require 'spec_helper'

RSpec.describe Player, type: :model do
  describe "Destruction" do
    let(:tournament) {FactoryGirl::create(:tournament_with_all)}
    let(:player) {
      team = tournament.groups.last.group_members.last.team
      tournament.playoff_fights.first.team_fight.shiro_team = team
      tournament.playoff_fights.first.team_fight.save
      player = team.team_memberships.last.player
      fight = tournament.playoff_fights.first.team_fight.fights.create(aka: tournament.playoff_fights.first.team_fight.aka_team.team_memberships.last.player, shiro: player, state: :started)
      fight.save!
      point = fight.points.create
      point.save
      fight.points.create(player: player)
      player
    }
    let(:player_id) {player.id}

    it "nullifies all player points" do
      points = player.point_ids.to_ary
      player.destroy
      expect(Point.where(player_id: player_id)).to be_empty
      for point_id in points
        expect(Point.exists?(id: point_id)).to be(true)
      end
    end

    it "destroys all tournament particiaptions" do
      player.destroy
      expect(TournamentParticipation.exists?(player_id: player_id)).to be(false)
    end

    it "destroys all team memberships" do
      player.destroy
      expect(TeamMembership.exists?(player_id: player_id)).to be(false)
    end

    it "nullifies all fights" do
      player.destroy
      expect(Fight.exists?(aka_id: player_id)).to be(false)
      expect(Fight.exists?(shiro_id: player_id)).to be(false)
    end
  end
end
