module TournamentsPresenceHelpers
  extend ActiveSupport::Concern
  included do
    $ageConstraintMap = {
      "age_no_constraint" => "-",
      "age_less_or_equal" => "<=",
      "age_greater_or_equal" => ">=",
      "age_equal" => "=="
    }

    $rankConstraintMap = {
      "rank_no_constraint" => "-",
      "rank_less_or_equal" => "<=",
      "rank_greater_or_equal" => ">=",
      "rank_equal" => "=="
    }

    def expectPageToContainTournament(page, tournament)
      expect(page).to have_content(tournament[:name])
      expect(page).to have_content(tournament[:address])
      #expect(page).to have_content(tournament[:date])
      expect(page).to have_content(tournament[:playoff_match_length])
      expect(page).to have_content(tournament[:group_match_length])
      expect(page).to have_content(tournament[:team_size])
      if tournament[:player_sex_constraint_value] != "all_allowed"
        if tournament[:player_sex_constraint_value] == "men_only"
          expect(page).to have_content("Men only")
        else
          expect(page).to have_content("Women only")
        end
      end
      if tournament[:player_age_constraint] != "age_no_constraint"
        expect(page).to have_content("#{$ageConstraintMap[tournament[:player_age_constraint]]} #{tournament[:player_age_constraint_value]}")
      end
      if tournament[:player_rank_constraint] != "rank_no_constraint"
        tokens = tournament[:player_rank_constraint_value].split('_')
        expect(page).to have_content("#{$rankConstraintMap[tournament[:player_rank_constraint]]} #{tokens[1]} #{tokens[0].upcase}")
      end
    end
  end
end