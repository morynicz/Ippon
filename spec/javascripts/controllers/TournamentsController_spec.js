describe(
    'TournamentsController',
    function() {
      var scope = null;
      var ctrl = null;
      var location = null;
      var stateParams = null;
      var resource = null;
      var httpBackend = null;
      var fakePlayerId = 42;
      var fakeClubId = 77;
      var fakeTeamId = 17;
      var fakeTournamentId = 33;

      var fakePlayer = {
        "id" : fakePlayerId,
        "name" : "Tia",
        "surname" : "Pollich",
        "birthday" : "1994-07-26",
        "rank" : "dan_4",
        "sex" : "female",
        "club_id" : fakeClubId
      };

      var fakeTeam = {
        id : fakeTeamId,
        name : "Team Name",
        required_size : 2,
        tournament_id : 33
      };

      var fakePlayers = [ {
        "id" : 71,
        "name" : "Tessie",
        "surname" : "Ryan",
        "birthday" : "1979-04-28",
        "rank" : "kyu_3",
        "sex" : "male",
        "club_id" : 71
      }, {
        "id" : 72,
        "name" : "Elza",
        "surname" : "Spinka",
        "birthday" : "1982-01-22",
        "rank" : "dan_1",
        "sex" : "male",
        "club_id" : 72
      } ];

      var fakeParticipants = [ {
        "id" : 1,
        "name" : "Name1",
        "surname" : "Surname1",
        "birthday" : "1997-04-26",
        "rank" : "dan_6",
        "sex" : "woman",
        "club_id" : 1
      }, {
        "id" : 2,
        "name" : "Name2",
        "surname" : "Surname2",
        "birthday" : "1967-07-22",
        "rank" : "kyu_5",
        "sex" : "man",
        "club_id" : 2
      }, {
        "id" : 3,
        "name" : "Name3",
        "surname" : "Surname3",
        "birthday" : "1980-04-13",
        "rank" : "kyu_3",
        "sex" : "man",
        "club_id" : 3
      }, {
        "id" : 4,
        "name" : "Name4",
        "surname" : "Surname4",
        "birthday" : "1992-11-16",
        "rank" : "dan_2",
        "sex" : "woman",
        "club_id" : 4
      }, {
        "id" : 5,
        "name" : "Name5",
        "surname" : "Surname5",
        "birthday" : "2010-04-14",
        "rank" : "dan_5",
        "sex" : "woman",
        "club_id" : 5
      }, {
        "id" : 6,
        "name" : "Name6",
        "surname" : "Surname6",
        "birthday" : "1981-06-22",
        "rank" : "dan_3",
        "sex" : "man",
        "club_id" : 6
      }, {
        "id" : 7,
        "name" : "Name7",
        "surname" : "Surname7",
        "birthday" : "1998-08-25",
        "rank" : "dan_4",
        "sex" : "man",
        "club_id" : 7
      }, {
        "id" : 8,
        "name" : "Name8",
        "surname" : "Surname8",
        "birthday" : "1985-07-22",
        "rank" : "dan_1",
        "sex" : "man",
        "club_id" : 8
      }, {
        "id" : 9,
        "name" : "Name9",
        "surname" : "Surname9",
        "birthday" : "1989-11-28",
        "rank" : "dan_4",
        "sex" : "man",
        "club_id" : 9
      }, {
        "id" : 10,
        "name" : "Name10",
        "surname" : "Surname10",
        "birthday" : "1990-01-18",
        "rank" : "kyu_6",
        "sex" : "woman",
        "club_id" : 10
      }, {
        "id" : 11,
        "name" : "Name11",
        "surname" : "Surname11",
        "birthday" : "1961-05-24",
        "rank" : "kyu_2",
        "sex" : "woman",
        "club_id" : 11
      }, {
        "id" : 12,
        "name" : "Name12",
        "surname" : "Surname12",
        "birthday" : "1976-08-11",
        "rank" : "dan_1",
        "sex" : "woman",
        "club_id" : 12
      }, {
        "id" : 13,
        "name" : "Name13",
        "surname" : "Surname13",
        "birthday" : "1957-10-02",
        "rank" : "dan_7",
        "sex" : "man",
        "club_id" : 13
      }, {
        "id" : 14,
        "name" : "Name14",
        "surname" : "Surname14",
        "birthday" : "1968-02-01",
        "rank" : "kyu_6",
        "sex" : "woman",
        "club_id" : 14
      }, {
        "id" : 15,
        "name" : "Name15",
        "surname" : "Surname15",
        "birthday" : "1989-10-19",
        "rank" : "dan_2",
        "sex" : "woman",
        "club_id" : 15
      }, {
        "id" : 16,
        "name" : "Name16",
        "surname" : "Surname16",
        "birthday" : "1967-09-30",
        "rank" : "dan_3",
        "sex" : "man",
        "club_id" : 16
      } ];

      var fakeTournament = {
        "id" : 28,
        "name" : "Gutmannfort Shiai",
        "team_size" : 3,
        "playoff_match_length" : 3,
        "group_match_length" : 3,
        "player_age_constraint" : 0,
        "player_age_constraint_value" : 0,
        "player_rank_constraint" : 0,
        "player_rank_constraint_value" : 0,
        "player_sex_constraint" : 0,
        "player_sex_constraint_value" : 0
      };

      var fakeGroups = [ {
        "group" : {
          "id" : 54,
          "name" : "Group A",
          "tournament_id" : 28
        },
        "teams" : [ {
          "id" : 119,
          "name" : "quas",
          "tournament_id" : 28
        }, {
          "id" : 120,
          "name" : "est",
          "tournament_id" : 28
        }, {
          "id" : 121,
          "name" : "omnis",
          "tournament_id" : 28
        } ],
        "team_fights" : [ {
          "id" : 71,
          "aka_team_id" : 119,
          "aka_score" : 0,
          "shiro_team_id" : 120,
          "shiro_score" : 0,
          "location_id" : 72,
          "state" : "started"
        }, {
          "id" : 72,
          "aka_team_id" : 119,
          "aka_score" : 0,
          "shiro_team_id" : 121,
          "shiro_score" : 0,
          "location_id" : 73,
          "state" : "started"
        }, {
          "id" : 73,
          "aka_team_id" : 120,
          "aka_score" : 0,
          "shiro_team_id" : 121,
          "shiro_score" : 0,
          "location_id" : 74,
          "state" : "started"
        } ]
      }, {
        "group" : {
          "id" : 55,
          "name" : "Group B",
          "tournament_id" : 28
        },
        "teams" : [ {
          "id" : 122,
          "name" : "delectus",
          "tournament_id" : 28
        }, {
          "id" : 123,
          "name" : "quaerat",
          "tournament_id" : 28
        }, {
          "id" : 124,
          "name" : "autem",
          "tournament_id" : 28
        } ],
        "team_fights" : [ {
          "id" : 74,
          "aka_team_id" : 122,
          "aka_score" : 0,
          "shiro_team_id" : 123,
          "shiro_score" : 0,
          "location_id" : 75,
          "state" : "started"
        }, {
          "id" : 75,
          "aka_team_id" : 122,
          "aka_score" : 0,
          "shiro_team_id" : 124,
          "shiro_score" : 0,
          "location_id" : 76,
          "state" : "started"
        }, {
          "id" : 76,
          "aka_team_id" : 123,
          "aka_score" : 0,
          "shiro_team_id" : 124,
          "shiro_score" : 0,
          "location_id" : 77,
          "state" : "started"
        } ]
      } ];

      var fakeTeams = [ {
        "team" : {
          "id" : 119,
          "name" : "quas",
          "tournament_id" : 28
        },
        "players" : [ {
          "id" : 241,
          "name" : "Name1",
          "surname" : "Surname1",
          "birthday" : "1984-08-20",
          "rank" : "kyu_3",
          "sex" : "woman",
          "club_id" : 241
        }, {
          "id" : 242,
          "name" : "Name2",
          "surname" : "Surname2",
          "birthday" : "1982-10-24",
          "rank" : "dan_4",
          "sex" : "man",
          "club_id" : 242
        }, {
          "id" : 243,
          "name" : "Name3",
          "surname" : "Surname3",
          "birthday" : "1999-04-05",
          "rank" : "dan_4",
          "sex" : "man",
          "club_id" : 243
        } ]
      }, {
        "team" : {
          "id" : 120,
          "name" : "est",
          "tournament_id" : 28
        },
        "players" : [ {
          "id" : 244,
          "name" : "Name4",
          "surname" : "Surname4",
          "birthday" : "1994-01-23",
          "rank" : "dan_2",
          "sex" : "man",
          "club_id" : 244
        }, {
          "id" : 245,
          "name" : "Name5",
          "surname" : "Surname5",
          "birthday" : "1962-11-29",
          "rank" : "dan_6",
          "sex" : "man",
          "club_id" : 245
        }, {
          "id" : 246,
          "name" : "Name6",
          "surname" : "Surname6",
          "birthday" : "2004-02-13",
          "rank" : "dan_3",
          "sex" : "man",
          "club_id" : 246
        } ]
      }, {
        "team" : {
          "id" : 121,
          "name" : "omnis",
          "tournament_id" : 28
        },
        "players" : [ {
          "id" : 247,
          "name" : "Name7",
          "surname" : "Surname7",
          "birthday" : "1964-07-27",
          "rank" : "dan_8",
          "sex" : "man",
          "club_id" : 247
        }, {
          "id" : 248,
          "name" : "Name8",
          "surname" : "Surname8",
          "birthday" : "2008-12-31",
          "rank" : "dan_6",
          "sex" : "man",
          "club_id" : 248
        }, {
          "id" : 249,
          "name" : "Name9",
          "surname" : "Surname9",
          "birthday" : "2004-02-18",
          "rank" : "dan_7",
          "sex" : "woman",
          "club_id" : 249
        } ]
      }, {
        "team" : {
          "id" : 122,
          "name" : "delectus",
          "tournament_id" : 28
        },
        "players" : [ {
          "id" : 250,
          "name" : "Name10",
          "surname" : "Surname10",
          "birthday" : "1985-12-30",
          "rank" : "kyu_2",
          "sex" : "man",
          "club_id" : 250
        }, {
          "id" : 251,
          "name" : "Name11",
          "surname" : "Surname11",
          "birthday" : "1972-08-16",
          "rank" : "dan_3",
          "sex" : "woman",
          "club_id" : 251
        }, {
          "id" : 252,
          "name" : "Name12",
          "surname" : "Surname12",
          "birthday" : "1963-04-30",
          "rank" : "dan_7",
          "sex" : "woman",
          "club_id" : 252
        } ]
      }, {
        "team" : {
          "id" : 123,
          "name" : "quaerat",
          "tournament_id" : 28
        },
        "players" : [ {
          "id" : 253,
          "name" : "Name13",
          "surname" : "Surname13",
          "birthday" : "1958-02-26",
          "rank" : "kyu_4",
          "sex" : "woman",
          "club_id" : 253
        }, {
          "id" : 254,
          "name" : "Name14",
          "surname" : "Surname14",
          "birthday" : "1994-12-10",
          "rank" : "kyu_6",
          "sex" : "woman",
          "club_id" : 254
        }, {
          "id" : 255,
          "name" : "Name15",
          "surname" : "Surname15",
          "birthday" : "1994-02-18",
          "rank" : "kyu_2",
          "sex" : "man",
          "club_id" : 255
        } ]
      }, {
        "team" : {
          "id" : 124,
          "name" : "autem",
          "tournament_id" : 28
        },
        "players" : [ {
          "id" : 256,
          "name" : "Name16",
          "surname" : "Surname16",
          "birthday" : "1983-06-13",
          "rank" : "dan_4",
          "sex" : "man",
          "club_id" : 256
        }, {
          "id" : 257,
          "name" : "Name17",
          "surname" : "Surname17",
          "birthday" : "1974-09-27",
          "rank" : "kyu_3",
          "sex" : "woman",
          "club_id" : 257
        }, {
          "id" : 258,
          "name" : "Name18",
          "surname" : "Surname18",
          "birthday" : "1965-02-11",
          "rank" : "kyu_5",
          "sex" : "man",
          "club_id" : 258
        } ]
      }, {
        "team" : {
          "id" : 125,
          "name" : "delectus",
          "tournament_id" : 28
        },
        "players" : [ {
          "id" : 259,
          "name" : "Name19",
          "surname" : "Surname19",
          "birthday" : "1979-06-28",
          "rank" : "kyu_6",
          "sex" : "woman",
          "club_id" : 259
        }, {
          "id" : 260,
          "name" : "Name20",
          "surname" : "Surname20",
          "birthday" : "1977-09-18",
          "rank" : "dan_7",
          "sex" : "man",
          "club_id" : 260
        }, {
          "id" : 261,
          "name" : "Name21",
          "surname" : "Surname21",
          "birthday" : "2004-10-26",
          "rank" : "dan_5",
          "sex" : "man",
          "club_id" : 261
        } ]
      }, {
        "team" : {
          "id" : 126,
          "name" : "minima",
          "tournament_id" : 28
        },
        "players" : [ {
          "id" : 262,
          "name" : "Name22",
          "surname" : "Surname22",
          "birthday" : "1992-08-07",
          "rank" : "kyu_5",
          "sex" : "woman",
          "club_id" : 262
        }, {
          "id" : 263,
          "name" : "Name23",
          "surname" : "Surname23",
          "birthday" : "1975-10-01",
          "rank" : "dan_4",
          "sex" : "man",
          "club_id" : 263
        }, {
          "id" : 264,
          "name" : "Name24",
          "surname" : "Surname24",
          "birthday" : "2006-05-20",
          "rank" : "dan_7",
          "sex" : "man",
          "club_id" : 264
        } ]
      } ];

      var fakePlayoffFights = [ {
        "playoff_fight" : {
          "id" : 24,
          "tournament_id" : 28,
          "team_fight_id" : 77,
          "previous_aka_fight_id" : null,
          "previous_shiro_fight_id" : null
        },
        "team_fight" : {
          "id" : 77,
          "aka_team_id" : 126,
          "aka_score" : 0,
          "shiro_team_id" : 125,
          "shiro_score" : 0,
          "location_id" : 78,
          "state" : "started"
        }
      }, {
        "playoff_fight" : {
          "id" : 25,
          "tournament_id" : 28,
          "team_fight_id" : null,
          "previous_aka_fight_id" : 24,
          "previous_shiro_fight_id" : null
        },
        "team_fight" : []
      } ];

      var fakeParticipants = [ {
        "id" : 241,
        "name" : "Name1",
        "surname" : "Surname1",
        "birthday" : "1984-08-20",
        "rank" : "kyu_3",
        "sex" : "woman",
        "club_id" : 241
      }, {
        "id" : 242,
        "name" : "Name2",
        "surname" : "Surname2",
        "birthday" : "1982-10-24",
        "rank" : "dan_4",
        "sex" : "man",
        "club_id" : 242
      }, {
        "id" : 243,
        "name" : "Name3",
        "surname" : "Surname3",
        "birthday" : "1999-04-05",
        "rank" : "dan_4",
        "sex" : "man",
        "club_id" : 243
      }, {
        "id" : 244,
        "name" : "Name4",
        "surname" : "Surname4",
        "birthday" : "1994-01-23",
        "rank" : "dan_2",
        "sex" : "man",
        "club_id" : 244
      }, {
        "id" : 245,
        "name" : "Name5",
        "surname" : "Surname5",
        "birthday" : "1962-11-29",
        "rank" : "dan_6",
        "sex" : "man",
        "club_id" : 245
      }, {
        "id" : 246,
        "name" : "Name6",
        "surname" : "Surname6",
        "birthday" : "2004-02-13",
        "rank" : "dan_3",
        "sex" : "man",
        "club_id" : 246
      }, {
        "id" : 247,
        "name" : "Name7",
        "surname" : "Surname7",
        "birthday" : "1964-07-27",
        "rank" : "dan_8",
        "sex" : "man",
        "club_id" : 247
      }, {
        "id" : 248,
        "name" : "Name8",
        "surname" : "Surname8",
        "birthday" : "2008-12-31",
        "rank" : "dan_6",
        "sex" : "man",
        "club_id" : 248
      }, {
        "id" : 249,
        "name" : "Name9",
        "surname" : "Surname9",
        "birthday" : "2004-02-18",
        "rank" : "dan_7",
        "sex" : "woman",
        "club_id" : 249
      }, {
        "id" : 250,
        "name" : "Name10",
        "surname" : "Surname10",
        "birthday" : "1985-12-30",
        "rank" : "kyu_2",
        "sex" : "man",
        "club_id" : 250
      }, {
        "id" : 251,
        "name" : "Name11",
        "surname" : "Surname11",
        "birthday" : "1972-08-16",
        "rank" : "dan_3",
        "sex" : "woman",
        "club_id" : 251
      }, {
        "id" : 252,
        "name" : "Name12",
        "surname" : "Surname12",
        "birthday" : "1963-04-30",
        "rank" : "dan_7",
        "sex" : "woman",
        "club_id" : 252
      }, {
        "id" : 253,
        "name" : "Name13",
        "surname" : "Surname13",
        "birthday" : "1958-02-26",
        "rank" : "kyu_4",
        "sex" : "woman",
        "club_id" : 253
      }, {
        "id" : 254,
        "name" : "Name14",
        "surname" : "Surname14",
        "birthday" : "1994-12-10",
        "rank" : "kyu_6",
        "sex" : "woman",
        "club_id" : 254
      }, {
        "id" : 255,
        "name" : "Name15",
        "surname" : "Surname15",
        "birthday" : "1994-02-18",
        "rank" : "kyu_2",
        "sex" : "man",
        "club_id" : 255
      }, {
        "id" : 256,
        "name" : "Name16",
        "surname" : "Surname16",
        "birthday" : "1983-06-13",
        "rank" : "dan_4",
        "sex" : "man",
        "club_id" : 256
      }, {
        "id" : 257,
        "name" : "Name17",
        "surname" : "Surname17",
        "birthday" : "1974-09-27",
        "rank" : "kyu_3",
        "sex" : "woman",
        "club_id" : 257
      }, {
        "id" : 258,
        "name" : "Name18",
        "surname" : "Surname18",
        "birthday" : "1965-02-11",
        "rank" : "kyu_5",
        "sex" : "man",
        "club_id" : 258
      }, {
        "id" : 259,
        "name" : "Name19",
        "surname" : "Surname19",
        "birthday" : "1979-06-28",
        "rank" : "kyu_6",
        "sex" : "woman",
        "club_id" : 259
      }, {
        "id" : 260,
        "name" : "Name20",
        "surname" : "Surname20",
        "birthday" : "1977-09-18",
        "rank" : "dan_7",
        "sex" : "man",
        "club_id" : 260
      }, {
        "id" : 261,
        "name" : "Name21",
        "surname" : "Surname21",
        "birthday" : "2004-10-26",
        "rank" : "dan_5",
        "sex" : "man",
        "club_id" : 261
      }, {
        "id" : 262,
        "name" : "Name22",
        "surname" : "Surname22",
        "birthday" : "1992-08-07",
        "rank" : "kyu_5",
        "sex" : "woman",
        "club_id" : 262
      }, {
        "id" : 263,
        "name" : "Name23",
        "surname" : "Surname23",
        "birthday" : "1975-10-01",
        "rank" : "dan_4",
        "sex" : "man",
        "club_id" : 263
      }, {
        "id" : 264,
        "name" : "Name24",
        "surname" : "Surname24",
        "birthday" : "2006-05-20",
        "rank" : "dan_7",
        "sex" : "man",
        "club_id" : 264
      } ];

      var setupController = function(stateName, tournamentId) {
        return inject(function($location, $stateParams, $rootScope, $resource,
            $httpBackend, $controller, $state, $templateCache) {
          scope = $rootScope.$new();
          location = $location;
          resource = $resource;
          stateParams = $stateParams;
          httpBackend = $httpBackend;

          state = $state;

          $templateCache.put('Tournaments/_show.html', '');
          $templateCache.put('Tournaments/_form.html', '');

          state.go(stateName);
          $rootScope.$apply();

          if (tournamentId) {
            stateParams.tournamentId = tournamentId;
          }

          ctrl = $controller('TournamentsController', {
            $scope : scope,
            $location : location,
            $state : state
          });
        });
      };

      beforeEach(module('ippon'));

      afterEach(function() {
        httpBackend.verifyNoOutstandingExpectation();
        httpBackend.verifyNoOutstandingRequest();
      });

      var expectGetGroups = function(tournamentId, status, groups) {
        var request = new RegExp("tournaments/" + tournamentId + "/groups");
        var response = groups ? groups : [];

        httpBackend.expectGET(request).respond(status, response);
      }

      var expectGetPlayoffFights = function(tournamentId, status, playoffFights) {
        var request = new RegExp("tournaments/" + tournamentId
            + "/playoff_fights");
        var response = playoffFights ? playoffFights : [];

        httpBackend.expectGET(request).respond(status, response);
      }

      var expectGetTeams = function(tournamentId, status, teams) {
        var request = new RegExp("tournaments/" + tournamentId + "/teams");
        var response = teams ? teams : [];

        httpBackend.expectGET(request).respond(status, response);
      }

      var expectGetParticipants = function(tournamentId, status, participants,
          players) {
        var request = new RegExp("tournaments/" + tournamentId
            + "/participants");
        var response = {};
        if (participants || players) {
          response.participants = participants ? participants : [];
          response.players = players ? players : [];
        }
        httpBackend.expectGET(request).respond(status, response);
      }

      var expectGetTournament = function(tournamentId, status, tournament) {
        var request = new RegExp("tournaments/" + tournamentId);
        var response = tournament ? tournament : {};

        response.id = tournamentId;
        httpBackend.expectGET(request).respond(status, response);
      };

      var expectGetTournamentNotFound = function(tournamentId) {
        var request = new RegExp("tournaments/" + tournamentId);
        httpBackend.expectGET(request).respond(404, null);
      }

      var expectFlashToExist = function(method, target, error, severity) {
        var flashes = scope.flashes;
        for(var i = 0; i < scope.flashes.length; ++i) {
          var hasType = (flashes[i].type === severity);
          var hasMethod = 0 <= flashes[i].text.indexOf(method);
          var hasTarget = 0 <= flashes[i].text.indexOf(target);
          var hasError = 0 <= flashes[i].text.indexOf(error);
          if( hasType && hasMethod && hasTarget && hasError) {
            return;
          }
        }
        fail("Flash with severity: "+severity+" and text containing: " + method+" "+target+" "+error+ " not found");
      }
      
      describe('show', function() {
        describe('tournament is found', function() {
          beforeEach(function() {
            setupController('tournaments_show', fakeTournamentId);
            expectGetTournament(fakeTournamentId, 200, fakeTournament);
            expectGetGroups(fakeTournamentId, 200, fakeGroups);
            expectGetTeams(fakeTournamentId, 200, fakeTeams);
            expectGetParticipants(fakeTournamentId, 200, fakeParticipants, []);
            fakeTournament.is_admin = false;
            expectGetPlayoffFights(fakeTournamentId, 200, fakePlayoffFights);
          });
          it('loads the given tournament', function() {
            httpBackend.flush();
            expect(scope.tournament).toEqualData(fakeTournament);
            expect(scope.playoff_fights).toContainDataFromArray(
                fakePlayoffFights);
            expect(scope.groups).toEqualData(fakeGroups);
            expect(scope.teams).toEqualData(fakeTeams);
            expect(scope.participants).toEqualData(fakeParticipants);
            expect(scope.is_admin).toBe(false);
          });
        });

        describe('tournament is not found', function() {
          beforeEach(function() {
            setupController('tournaments_show', fakeTournamentId);
            expectGetTournament(fakeTournamentId, 404);
            expectGetGroups(fakeTournamentId, 404);
            expectGetTeams(fakeTournamentId, 404);
            expectGetParticipants(fakeTournamentId, 404);
            fakeTournament.is_admin = false;
            expectGetPlayoffFights(fakeTournamentId, 404);
          });
          it("doesn't load a tournament", function() {
            httpBackend.flush();
            expect(scope.tournament).toEqualData(null);
            expect(scope.playoff_fights).toEqualData(null);
            expect(scope.groups).toEqualData(null);
            expect(scope.participants).toEqualData(null);
            expect(scope.is_admin).toBe(false);
            expectFlashToExist('GET','TOURNAMENT','ERROR_FAILED','danger');
            expectFlashToExist('GET','GROUPS','ERROR_FAILED','danger');
            expectFlashToExist('GET','TEAMS','ERROR_FAILED','danger');
            expectFlashToExist('GET','PARTICIPANTS','ERROR_FAILED','danger');
            expectFlashToExist('GET','PLAYOFF_FIGHTS','ERROR_FAILED','danger');
          });
        });
      });

      describe('create', function() {
        var newTournament = {
          name: "Czar Par",
          team_size: 3,
          playoff_match_length: 4,
          group_match_length: 3,
          player_age_constraint: 0,
          player_age_constraint_value: 0,
          player_rank_constraint: 1,
          player_rank_constraint_value: 5,
          player_sex_constraint: 0,
          player_sex_constraint_value: 0,
        };

        beforeEach(function() {
          setupController('tournaments_new', false);
          var request = new RegExp("tournaments");
          httpBackend.expectPOST(request).respond(201, newTournament);
        });

        it('posts to the backend', function() {
          scope.tournament.name = newTournament.name;
          scope.tournament.team_size = newTournament.team_size;
          scope.tournament.playoff_match_length = newTournament.playoff_match_length;
          scope.tournament.group_match_length = newTournament.group_match_length;
          scope.tournament.player_age_constraint = newTournament.player_age_constraint;
          scope.tournament.player_age_constraint_value = newTournament.player_age_constraint_value;
          scope.tournament.player_rank_constraint = newTournament.player_rank_constraint;
          scope.tournament.player_rank_constraint_value = newTournament.player_rank_constraint_value;
          scope.tournament.player_sex_constraint = newTournament.player_sex_constraint;
          scope.tournament.player_sex_constraint_value = newTournament.player_sex_constraint_value;

          scope.save();
          scope.$apply();
          httpBackend.flush();
          expect('#' + location.path()).toBe(state.href('tournaments_show'));
          expect(state.is('tournaments_show')).toBe(true);
        });
      });

      describe('update', function() {
        var updatedTournament = {
            name: "Czar Par",
            team_size: 3,
            playoff_match_length: 4,
            group_match_length: 3,
            player_age_constraint: 0,
            player_age_constraint_value: 0,
            player_rank_constraint: 1,
            player_rank_constraint_value: 5,
            player_sex_constraint: 0,
            player_sex_constraint_value: 0,
          };

        beforeEach(function() {
          setupController('tournaments_edit', fakeTournamentId);
          expectGetTournament(fakeTournamentId, 200, fakeTournament);
          httpBackend.flush();
          var request = new RegExp("tournaments/");
          httpBackend.expectPUT(request).respond(204);
        });

        it('posts to the backend', function() {
          scope.tournament.name = updatedTournament.name;
          scope.tournament.team_size = updatedTournament.team_size;
          scope.tournament.playoff_match_length = updatedTournament.playoff_match_length;
          scope.tournament.group_match_length = updatedTournament.group_match_length;
          scope.tournament.player_age_constraint = updatedTournament.player_age_constraint;
          scope.tournament.player_age_constraint_value = updatedTournament.player_age_constraint_value;
          scope.tournament.player_rank_constraint = updatedTournament.player_rank_constraint;
          scope.tournament.player_rank_constraint_value = updatedTournament.player_rank_constraint_value;
          scope.tournament.player_sex_constraint = updatedTournament.player_sex_constraint;
          scope.tournament.player_sex_constraint_value = updatedTournament.player_sex_constraint_value;
          scope.save();
          httpBackend.flush();
          expect('#'+location.path()).toBe(state.href('tournaments_show',{tournamentId: scope.tournament.id}));
          expect(state.is('tournaments_show')).toBe(true);

          expect(scope.tournament.name).toBe(updatedTournament.name);
          expect(scope.tournament.team_size).toBe(updatedTournament.team_size);
          expect(scope.tournament.playoff_match_length).toBe(updatedTournament.playoff_match_length);
          expect(scope.tournament.group_match_length).toBe(updatedTournament.group_match_length);
          expect(scope.tournament.player_age_constraint).toBe(updatedTournament.player_age_constraint);
          expect(scope.tournament.player_age_constraint_value).toBe(updatedTournament.player_age_constraint_value);
          expect(scope.tournament.player_rank_constraint).toBe(updatedTournament.player_rank_constraint);
          expect(scope.tournament.player_rank_constraint_value).toBe(updatedTournament.player_rank_constraint_value);
          expect(scope.tournament.player_sex_constraint).toBe(updatedTournament.player_sex_constraint);
          expect(scope.tournament.player_sex_constraint_value).toBe(updatedTournament.player_sex_constraint_value);
        });
      });

      describe('delete', function() {
        beforeEach(function() {
          setupController('tournaments_show', fakeTournamentId);
          expectGetTournament(fakeTournamentId, 200, fakeTournament);
          expectGetGroups(fakeTournamentId, 200, fakeGroups);
          expectGetTeams(fakeTournamentId, 200, fakeTeams);
          expectGetParticipants(fakeTournamentId, 200, fakeParticipants, []);
          fakeTournament.is_admin = false;
          expectGetPlayoffFights(fakeTournamentId, 200, fakePlayoffFights);
          httpBackend.flush();
          var request = new RegExp("tournaments/" + scope.tournament.id);
          httpBackend.expectDELETE(request).respond(204);
        });

        it('posts to the backend', function() {
          scope["delete"]();
          scope.$apply();
          httpBackend.flush();
          expect('#'+ location.path()).toBe(state.href('home'));
        });
      });
    });