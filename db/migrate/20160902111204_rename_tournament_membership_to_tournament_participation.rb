class RenameTournamentMembershipToTournamentParticipation < ActiveRecord::Migration
  def change
    rename_table :tournament_memberships, :tournament_participations
  end
end
