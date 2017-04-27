require 'rails_helper'

RSpec.describe TournamentsController, type: :controller do
  render_views

  def authorize_user(tournament_id)
    TournamentAdmin.create(tournament_id: tournament_id,
      user_id: current_user.id, status: :main)
  end

  def expectTournamentDataEqHash(tournament, tournament_attrs)
    expect(tournament.name).to eq(tournament_attrs[:name])
    expect(tournament.date).to eq(tournament_attrs[:date])
    expect(tournament.address).to eq(tournament_attrs[:address])
    expect(tournament.city).to eq(tournament_attrs[:city])
    expect(tournament.playoff_match_length).to eq(tournament_attrs[:playoff_match_length])
    expect(tournament.group_match_length).to eq(tournament_attrs[:group_match_length])
    expect(tournament.team_size).to eq(tournament_attrs[:team_size])
    expect(tournament.player_age_constraint).to eq(tournament_attrs[:player_age_constraint])
    expect(tournament.player_age_constraint_value).to eq(tournament_attrs[:player_age_constraint_value])
    expect(tournament.player_sex_constraint).to eq(tournament_attrs[:player_sex_constraint])
    expect(tournament.player_sex_constraint_value).to eq(tournament_attrs[:player_sex_constraint_value])
    expect(tournament.player_rank_constraint).to eq(tournament_attrs[:player_rank_constraint])
    expect(tournament.player_rank_constraint_value).to eq(tournament_attrs[:player_rank_constraint_value])
  end

  describe "GET show" do
    let(:action) {
      xhr :get, :show, format: :json, id: tournament_id
    }

    subject(:results) {JSON.parse(response.body)}

    context "when the tournament exists" do
      let(:tournament) {
        FactoryGirl::create(:tournament)
      }
      let(:tournament_id){tournament.id}

      it "should return 200 status" do
        action
        expect(response.status).to eq(200)
      end

      it "should return result with correct id" do
        action
        expect(results["id"]).to eq(tournament.id)
      end

      it "should return result with correct name" do
        action
        expect(results["name"]).to eq(tournament.name)
      end

      it "should return result with tournament size" do
        action
        expect(results["team_size"]).to eq(tournament.team_size)
      end

      it "should return result with correct player age constraint" do
        action
        expect(results["player_age_constraint"]).
          to eq(tournament.player_age_constraint)
        expect(results["player_age_constraint_value"]).
          to eq(tournament.player_age_constraint_value)
      end

      it "should return result with correct player rank constraint" do
        action
        expect(results["player_rank_constraint"]).
          to eq(tournament.player_rank_constraint)
        expect(results["player_rank_constraint_value"]).
          to eq(tournament.player_rank_constraint_value)
      end

      it "should return result with correct player sex constraint" do
        action
        expect(results["player_sex_constraint"]).
          to eq(tournament.player_sex_constraint)
      end

      it "should return result with correct city" do
        action
        expect(results["city"]).
          to eq(tournament.city)
      end

      it "should return result with correct address" do
        action
        expect(results["address"]).
          to eq(tournament.address)
      end

      it "should return result with correct date" do
        action
        expect(results["date"]).
          to eq(tournament.date.to_s(:db))
      end

      context "when the user is not an admin" do
        it "should return admin status false" do
          action
          expect(results["is_admin"]).to be false
        end
      end

      context "when the user is an admin", authenticated: true do
        context "when the user is not an admin" do
          it "should return admin status true" do
            authorize_user(tournament.id)
            action
            expect(results["is_admin"]).to be true
          end
        end
      end
    end

    context "when tournament doesn't exist" do
      let(:tournament_id) {-9999}
      it "should respond with 404 status" do
        action
        expect(response.status).to eq(404)
      end
    end
  end

  describe "POST: create" do
    let(:attributes){FactoryGirl::attributes_for(:tournament)}

    let(:action){
      xhr :post, :create, format: :json, tournament: attributes
    }

    context "when the user is not authenticated" do
      it "does not create a tournament" do
        expect {
          action
        }.to_not change(Tournament, :count)
      end

      it "denies access" do
        action
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when the user is authenticated", authenticated: true do
      context "with invalid attributes" do

        let(:attributes) do
          {
            name: "",
            playoff_match_length: 0,
            group_match_length: 0,
            team_size: 0,
            player_age_constraint: '',
            player_age_constraint_value: '',
            player_sex_constraint: '',
            player_sex_constraint_value: '',
            player_rank_constraint: '',
            player_rank_constraint_value: '',
            date: '',
            address: '',
            city: ''
          }
        end

        it "does not create a tournament" do
          expect {
            action
          }.to_not change(Tournament, :count)
        end

        it "returns the correct status" do
          action
          expect(response).to have_http_status :unprocessable_entity
        end
      end
      context "with valid attributes" do
        it "creates a Tournament" do
          expect {
            action
          }.to change(Tournament, :count).by(1)
        end

        it "returns the correct status" do
          action
          expect(response).to be_successful
        end

        it "makes the creating user an admin" do
          action
          tournament = Tournament.find_by_name(attributes[:name])
          expect(TournamentAdmin.exists?(user_id: current_user.id,
            tournament_id: tournament.id)).to be true
          admin = TournamentAdmin.where(user_id: current_user.id,
            tournament_id: tournament.id).first

          expect(admin.status).to eq(:main.to_s)
        end
      end
    end
  end

  describe "index" do
    let(:tournament_list) {
      FactoryGirl::create_list(:tournament,3)
    }
    before do
      tournament_list
      xhr :get, :index, format: :json
    end

    subject(:results) { JSON.parse(response.body)}

    def extract_name
      ->(object) { object["name"]}
    end

    def extract_playoff_match_length
      ->(object) {object["playoff_match_length"]}
    end

    def extract_group_match_length
      ->(object) {object["group_match_length"]}
    end

    def extract_team_size
      ->(object) {object["team_size"]}
    end

    def extract_player_age_constraint
      ->(object) {object["player_age_constraint"]}
    end

    def extract_player_age_constraint_value
      ->(object) {object["player_age_constraint_value"]}
    end

    def extract_player_rank_constraint
      ->(object) {object["player_rank_constraint"]}
    end

    def extract_player_rank_constraint_value
      ->(object) {object["player_rank_constraint_value"]}
    end

    def extract_player_sex_constraint
      ->(object) {object["player_sex_constraint"]}
    end

    def extract_player_sex_constraint_value
      ->(object) {object["player_sex_constraint_value"]}
    end


    context "when we want the full list" do
      it "should 200" do
        expect(response.status).to eq(200)
      end

      it "should return all tournaments in results" do
        expect(results.size).to eq(Tournament.all.size)
      end

      it "should include all the values of all the tournaments" do
        for tournament in tournament_list do
          expect(results.map(&extract_name)).to include(tournament.name)
          expect(results.map(&extract_group_match_length)).
            to include(tournament.group_match_length)
          expect(results.map(&extract_playoff_match_length)).
            to include(tournament.playoff_match_length)
          expect(results.map(&extract_team_size)).
            to include(tournament.team_size)
          expect(results.map(&extract_player_age_constraint)).
            to include(tournament.player_age_constraint)
          expect(results.map(&extract_player_age_constraint_value)).
            to include(tournament.player_age_constraint_value)
          expect(results.map(&extract_player_rank_constraint)).
            to include(tournament.player_rank_constraint)
          expect(results.map(&extract_player_rank_constraint_value)).
            to include(tournament.player_rank_constraint_value)
          expect(results.map(&extract_player_sex_constraint)).
            to include(tournament.player_sex_constraint)
          expect(results.map(&extract_player_sex_constraint_value)).
            to include(tournament.player_sex_constraint_value)
        end
      end
    end
  end

  describe "PATCH update" do
    let(:action) {
      xhr :put, :update, format: :json, id: tournament.id,
        tournament: update_tournament_attrs
      tournament.reload
    }

    let(:update_tournament_attrs) {
      FactoryGirl::attributes_for(:tournament)
    }
    let(:tournament_attrs) {
      FactoryGirl::attributes_for(:tournament)
    }
    context "when the tournament exists" do
      let(:tournament) {
        Tournament.create(tournament_attrs)
      }

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(tournament.id)
        end
        context "when the update atttributes are valid" do
          it "should return correct status" do
            action
            expect(response.status).to eq(204)
          end

          it "should update tournament attributes" do
            action
            expectTournamentDataEqHash(tournament, update_tournament_attrs)
          end
        end

        context "when the update attributes are not valid" do
          let(:update_tournament_attrs) do
            {
              name: "",
              playoff_match_length: 0,
              group_match_length: 0,
              team_size: 0,
              player_age_constraint: '',
              player_age_constraint_value: '',
              player_sex_constraint: '',
              player_sex_constraint_value: '',
              player_rank_constraint: '',
              player_rank_constraint_value: '',
              date: '',
              address: '',
              city: ''
            }
          end

          it "should not update tournament attributes" do
            action
            expectTournamentDataEqHash(tournament, tournament_attrs)
          end

          it "should return unporcessable entity" do
            action
            expect(response).to have_http_status :unprocessable_entity
          end
        end
      end

      context "when the user isn't authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "should not update tournament attributes" do
          action
          expectTournamentDataEqHash(tournament, tournament_attrs)
        end
      end
    end

    context "when the tournament doesn't exist" do
      let(:tournament_id) {-9999}

      let(:action) {
        xhr :put, :update, format: :json, id: tournament_id,
          tournament: update_tournament_attrs
      }

      context "when user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end

  describe "DELETE: destroy" do
    let(:action) {
        xhr :delete, :destroy, format: :json, id: tournament_id
    }

    context "when the torunament exists" do
      let(:tournament) {
        FactoryGirl::create(:tournament_with_participants_and_admins)
      }
      let(:tournament_id){tournament.id}

      context "when the user is authorized", authenticated: true do
        before do
          authorize_user(tournament.id)
        end
        it "should respond with 204 status" do
          action
          expect(response.status).to eq(204)
        end

        it "should not be able to find deleted tournament" do
          action
          expect(Tournament.find_by_id(tournament.id)).to be_nil
        end

        it "should destroy all memberships of this tournament" do
          action
          expect(TournamentParticipation.exists?(tournament_id: tournament_id)).
            to be false
        end

        it "should delete all admins of this tournament" do
          action
          expect(TournamentAdmin.exists?(tournament_id: tournament_id)).
            to be false
        end
      end

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
        it "should not delete the tournament" do
          action
          expect(Tournament.exists?(tournament.id)).to be true
        end
      end
    end

    context "when the tournament doesn't exist" do
      let(:tournament_id) {-9999}

      context "when the user is not authorized" do
        it "should respond with unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end

  describe "GET: admins" do
    let(:tournament) {
      FactoryGirl::create(:tournament)
    }
    let(:action) {
      xhr :get, :admins, format: :json, id: tournament.id
    }

    before do
      admin_list = FactoryGirl::create_list(:user, 3)
      not_admin_list = FactoryGirl::create_list(:user,2)

      for admin in admin_list do
        TournamentAdmin.create(tournament_id: tournament.id, user_id: admin.id)
      end
    end

    subject(:results) {JSON.parse(response.body)}

    context "when the user is not authenticated" do
      it "returns unauthorized status" do
        action
        expect(response).to have_http_status :unauthorized
      end

      it "returns response with no admins or users" do
        action
        expect(results["admins"]).to be nil
        expect(results["users"]).to be nil
      end
    end

    context "when the user is authenticated", authenticated: true do
      context "when the user is not authorized" do
        it "returns unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "returns response body to be empty" do
          action
          expect(response.body.empty?).to be true
        end
      end

      context "when the user is authorized" do
        before do
          authorize_user(tournament.id)
        end

        it "returns success status" do
          action
          expect(response).to have_http_status :ok
        end

        it "returns all current admins" do
          action
          expect(results["admins"].size).to eq(tournament.admins.size)
        end

        it "returns two non-admin users" do
          action
          expect(results["users"].size).to eq((User.all - tournament.admins)
            .size)
        end
      end
    end
  end

  describe "POST add_admin" do

    let(:tournament) {
      FactoryGirl::create(:tournament)
    }

    let(:tested_user) {
      FactoryGirl::create(:user)
    }

    let(:action) {
      xhr :post, :add_admin, format: :json, id: tournament.id,
        user_id: tested_user.id
    }

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        action
        expect(response).to have_http_status :unauthorized
      end

      it "does not change number of admins" do
        expect {
          action
        }.to_not change(TournamentAdmin, :count)
      end
    end

    context "when user is authenticated", authenticated: true do
      context "when user is not authorized" do
        it "returns unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "does not change number of admins" do
          expect {
            action
          }.to_not change(TournamentAdmin, :count)
        end
      end

      context "when user is authorized" do
        before do
          authorize_user(tournament.id)
        end

        context "when added user is not admin already" do
          it "returns OK status" do
            action
            expect(response).to have_http_status :no_content
          end

          it "adds the user to admins of given tournament" do
            action
            expect(TournamentAdmin.where(tournament_id: tournament.id).size).
              to eq(2)
            expect(TournamentAdmin.exists?(tournament_id: tournament.id,
              user_id: tested_user.id)).to be true
          end
        end

        context "when the user is already an andmin" do
          before do
            TournamentAdmin.create(tournament_id: tournament.id,
            user_id: tested_user.id)
          end
          it "returns bad request status" do
            action
            expect(response).to have_http_status :bad_request
          end

          it "does not change admin count" do
            expect { action }.not_to change(TournamentAdmin, :count)
          end
        end

      end
    end
  end

  describe "DELETE delete_admin" do
    let(:tournament) {
      FactoryGirl::create(:tournament)
    }

    let(:tested_user) {
      FactoryGirl::create(:user)
    }

    let(:action) {
      xhr :delete, :delete_admin, format: :json, id: tournament.id,
      user_id: tested_user.id
    }

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        action
        expect(response).to have_http_status :unauthorized
      end

      it "does not change number of admins" do
        expect {
          action
        }.to_not change(TournamentAdmin, :count)
      end
    end

    context "when user is authenticated", authenticated: true do
      context "when user is not authorized" do
        it "returns unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "does not change number of admins" do
          expect {
            action
          }.to_not change(TournamentAdmin, :count)
        end
      end

      context "when user is authorized" do
        before do
          authorize_user(tournament.id)
        end

        context "when the deleted admin is not an admin" do
          it "returns bad request status" do
            action
            expect(response).to have_http_status :bad_request
          end

          it "does not change admin count" do
            expect { action }.not_to change(TournamentAdmin, :count)
          end
        end

        context "when the deleted admin is an admin" do

          context "when deleted admin is not the last" do
            before do
              TournamentAdmin.create(tournament_id: tournament.id,
                user_id: tested_user.id)
            end

            it "returns OK status" do
              action
              expect(response).to have_http_status :no_content
            end

            it "removes the deleted admin from admins of given tournament" do
              action
              expect(TournamentAdmin.where(tournament_id: tournament.id)
                .size).to eq(1)
              expect(TournamentAdmin.exists?(tournament_id: tournament.id,
                user_id: tested_user.id)).to be false
            end
          end

          context "when the deleted admin is the last admin" do
            let(:unadmin_self) {
              xhr :delete, :delete_admin, format: :json, id: tournament.id,
                user_id: current_user.id
            }
            it "returns bad request status" do
              unadmin_self
              expect(response).to have_http_status :bad_request
            end

            it "does not change admin count" do
              expect { unadmin_self }.not_to change(TournamentAdmin, :count)
            end
          end
        end
      end
    end
  end

  describe "GET: participants" do
    let(:tournament) {
      FactoryGirl::create(:tournament)
    }
    let(:action) {
      xhr :get, :participants, format: :json, id: tournament.id
    }

    before do
      participant_list = FactoryGirl::create_list(:player, 15)
      not_participant_list = FactoryGirl::create_list(:player,30)

      for participant in participant_list do
        TournamentParticipation.create(tournament_id: tournament.id,
          player_id: participant.id)
      end
    end

    subject(:results) {JSON.parse(response.body)}

      context "when the method is called" do
        it "returns success status" do
          action
          expect(response).to have_http_status :ok
        end

        it "returns fifteen current participants" do
          action
          expect(results["participants"].size).to eq(15)
        end

        it "returns all non-participants users" do
          action
          expect(results["players"].size).to eq((Player.all -
            tournament.players).size)
        end
    end
  end

  describe "POST add_participant" do

    let(:tournament) {
      FactoryGirl::create(:tournament_with_participants_and_admins)
    }

    let(:tested_player) {
      FactoryGirl::create(:player)
    }

    let(:action) {
      xhr :post, :add_participant, format: :json, id: tournament.id,
        player_id: tested_player.id
    }

    before do
      tournament
    end

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        action
        expect(response).to have_http_status :unauthorized
      end

      it "does not change number of participants" do
        expect {
          action
        }.to_not change(TournamentParticipation, :count)
      end
    end

    context "when user is authenticated", authenticated: true do
      context "when user is not authorized" do
        it "returns unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "does not change number of participants" do
          expect {
            action
          }.to_not change(TournamentParticipation, :count)
        end
      end

      context "when user is authorized" do
        before do
          authorize_user(tournament.id)
        end

        context "when added player is not participant already" do
          it "returns OK status" do
            action
            expect(response).to have_http_status :no_content
          end

          it "adds the player to participants of given tournament" do
            action
            expect(TournamentParticipation.exists?(tournament_id: tournament.id,
              player_id: tested_player.id)).to be true
          end

          it "does not change number of participants" do
            expect {
              action
            }.to change(TournamentParticipation, :count).by(1)
          end
        end

        context "when the user is already a participant" do
          before do
            TournamentParticipation.create(tournament_id: tournament.id,
              player_id: tested_player.id)
          end
          it "returns bad request status" do
            action
            expect(response).to have_http_status :bad_request
          end

          it "does not change admin count" do
            expect { action }.not_to change(TournamentParticipation, :count)
          end
        end
      end
    end
  end

  describe "DELETE delete_participant" do
    let(:tournament) {
      FactoryGirl::create(:tournament_with_participants_and_admins)
    }

    let(:player) {
      FactoryGirl::create(:player)
    }

    let(:action) {
      xhr :delete, :delete_participant, format: :json, id: tournament.id,
        player_id: player.id
    }

    before do
      tournament
    end

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        action
        expect(response).to have_http_status :unauthorized
      end

      it "does not change number of participants" do
        expect {
          action
        }.to_not change(TournamentParticipation, :count)
      end
    end

    context "when user is authenticated", authenticated: true do
      context "when user is not authorized" do
        it "returns unauthorized status" do
          action
          expect(response).to have_http_status :unauthorized
        end

        it "does not change number of admins" do
          expect {
            action
          }.to_not change(TournamentParticipation, :count)
        end
      end

      context "when user is authorized" do
        before do
          authorize_user(tournament.id)
        end

        context "when the deleted participant is not a participant" do
          it "returns bad request status" do
            action
            expect(response).to have_http_status :bad_request
          end

          it "does not change participant count" do
            expect { action }.not_to change(TournamentParticipation, :count)
          end
        end

        context "when the deleted participant is a participant" do
          before do
            TournamentParticipation.create(tournament_id: tournament.id,
              player_id: player.id)
          end
          it "returns OK status" do
            action
            expect(response).to have_http_status :no_content
          end

          it "removes the deleted participant from participants of given tournament" do
            action
            expect(TournamentParticipation.exists?(tournament_id: tournament.id,
              player_id: player.id)).to be false
          end

          context "when deleted participant belongs to a team" do
            let(:team) {
              FactoryGirl::create(:team, tournament_id: tournament.id)
            }
            let(:tournament2) {
              FactoryGirl::create(:tournament)
            }
            let(:team2) {
              FactoryGirl::create(:team, tournament_id: tournament2.id)
            }
            before do
              TeamMembership.create(team_id: team.id, player_id: player.id)
              TeamMembership.create(team_id: team2.id, player_id: player.id)
              TournamentParticipation.create(tournament_id: tournament2.id,
                player_id: player.id)
            end

            it "returns OK status" do
              action
              expect(response).to have_http_status :no_content
            end

            it "removes the deleted participant from participants of given tournament" do
              action
              expect(TournamentParticipation.exists?(tournament_id: tournament.
                id, player_id: player.id)).to be false
            end

            it "removes the deleted participant from the team he is member of" do
              action
              expect(TournamentParticipation.exists?(tournament_id: tournament.
                id, player_id: player.id)).to be false
            end

            it "does not affect the other tournament participations and team memberships of the player" do
              action
              expect(TournamentParticipation.exists?(tournament_id: tournament.
                id, player_id: player.id)).to be false
            end
          end
        end
      end
    end
  end

  describe "GET: unassigned_participants" do
    let(:tournament) {
      FactoryGirl::create(:tournament)
    }
    let(:action) {
      xhr :get, :unassigned_participants, format: :json, id: tournament.id
    }

    let(:participant_list) {
      participant_list = FactoryGirl::create_list(:player, 30)
      for participant in participant_list do
        TournamentParticipation.create(tournament_id: tournament.id,
          player_id: participant.id)
      end
    }

    let(:free_participant_list) {
      assigned_list = participant_list[1..10]

      for assigned in assigned_list do
        t = FactoryGirl::create(:team, tournament_id: tournament.id)
        TeamMembership.create(team_id: t.id, player_id: assigned.id)
      end
      participant_list - assigned_list
    }

    def extract_id
      ->(object) { object["id"]}
    end

    subject(:results) { JSON.parse(response.body)}

    before do
      free_participant_list
    end

    subject(:results) {JSON.parse(response.body)}

      context "when the method is called" do
        it "returns success status" do
          action
          expect(response).to have_http_status :ok
        end

        it "returns 20 unassigned participants" do
          action
          expect(results.size).to eq(20)
        end

        it "returns all unassigned players" do
          action
          for unassigned in free_participant_list do
            expect(results.map(&extract_id)).to include(unassigned.id)
          end
        end
    end
  end
end
