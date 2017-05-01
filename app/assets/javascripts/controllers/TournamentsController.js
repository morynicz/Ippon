angular
    .module('ippon')
    .controller(
        'TournamentsController',
        [
            '$scope',
            '$stateParams',
            '$location',
            '$resource',
            '$state',
            'Auth',
            'FlashingService',
            function($scope, $stateParams, $location, $resource, $state, Auth,
                FlashingService) {

              var tournamentsResource = $resource("tournaments/:tournamentId", {
                tournamentId : "@id",
                format : "json"
              }, {
                'create' : {
                  method : 'POST'
                },
                'save' : {
                  method : 'PUT'
                }
              });

              var groupsResource = $resource(
                  "tournaments/:tournamentId/groups", {
                    tournamentId : "@id",
                    format : "json"
                  });

              var teamsResource = $resource("tournaments/:tournamentId/teams",
                  {
                    tournamentId : "@id",
                    format : "json"
                  });

              var playoffFightsResource = $resource(
                  "tournaments/:tournamentId/playoff_fights", {
                    tournamentId : "@id",
                    format : "json"
                  });

              var participantsResource = $resource(
                  "tournaments/:tournamentId/participants", {
                    tournamentId : "@id",
                    format : "json"
                  });

              var groupFightsResource = $resource(
                  "tournaments/:groupId/group_fights", {
                    tournamentId : "@id",
                    format : "json"
                  });

              var getTournament = function(tournamentId, next) {
                tournamentsResource.get({
                  tournamentId : tournamentId
                }, function(response) {
                  $scope.tournament = response;
                  $scope.tournament.date = new Date($scope.tournament.date);
                  $scope.is_admin = response.is_admin;
                }, function(httpResponse) {
                  FlashingService.flashRestFailed("{{'GET' | translate}}",
                      "{{'TOURNAMENT' | translate }}", httpResponse);
                  $scope.tournament = null;
                  $scope.is_admin = false;
                });
              }

              var getGroups = function(tournamentId, next) {
                groupsResource.query({
                  tournamentId : tournamentId
                }, function(response) {
                  $scope.groups = response;
                }, function(httpResponse) {
                  FlashingService.flashRestFailed("{{'GET' | translate}}",
                      "{{'GROUPS' | translate }}", httpResponse);
                  $scope.groups = null;
                });
              }

              var getTeams = function(tournamentId, next) {
                teamsResource.query({
                  tournamentId : tournamentId
                }, function(response) {
                  $scope.teams = response;
                  next();
                }, function(httpResponse) {
                  FlashingService.flashRestFailed("{{'GET' | translate}}",
                      "{{'TEAMS' | translate }}", httpResponse);
                  $scope.teams = null;
                });
              }

              var getPlayoffFights = function(tournamentId, next) {
                playoffFightsResource.query({
                  tournamentId : tournamentId
                }, function(response) {
                  $scope.playoff_fights = response;
                  next();
                }, function(httpResponse) {
                  FlashingService.flashRestFailed("{{'GET' | translate}}",
                      "{{'PLAYOFF_FIGHTS' | translate }}", httpResponse);
                  $scope.playoff_fights = null;
                });
              }

              var getParticipants = function(tournamentId, next) {
                participantsResource.get({
                  tournamentId : tournamentId
                }, function(response) {
                  $scope.participants = response.participants;
                }, function(httpResponse) {
                  FlashingService.flashRestFailed("{{'GET' | translate}}",
                      "{{'PARTICIPANTS' | translate }}", httpResponse);
                  $scope.participants = null;
                });
              }

              var buildPlayoffMap = function() {
                $scope.playoff_map = {};
                for (var i = 0; i < $scope.playoff_fights.length; i = i + 1) {
                  $scope.playoff_map[$scope.playoff_fights[i].playoff_fight.id] = $scope.playoff_fights[i];
                }
              }

              var buildTeamsMap = function() {
                $scope.teams_map = {};
                for (var i = 0; i < $scope.teams.length; i = i + 1) {
                  $scope.teams_map[$scope.teams[i].team.id] = $scope.teams[i].team;
                }
              }

              var buildPlayoffTree = function() {
                if(0==$scope.playoff_fights.length) {
                  return;
                }
                buildPlayoffMap();
                var playoffs = $scope.playoff_fights;

                var playoff_map = jQuery.extend({}, $scope.playoff_map);

                for (playoff in playoff_map) {
                  if (null != playoff_map[playoff].playoff_fight.previous_aka_fight_id)
                    delete playoff_map[playoff_map[playoff].playoff_fight.previous_aka_fight_id]
                  if (null != playoff_map[playoff].playoff_fight.previous_shiro_fight_id)
                    delete playoff_map[playoff_map[playoff].playoff_fight.previous_shiro_fight_id]
                }
                var playoff_final = playoff_map[Object.keys(playoff_map)[0]];

                $scope.playoff_tree = playoff_final;

                buildTreeBranch($scope.playoff_tree);

                $scope.leveled_playoffs = buildLeveledPlayoffTree($scope.playoff_tree);

                for (var i = 0; i < $scope.playoff_fights.length; i = i + 1) {
                  var playoff = $scope.playoff_fights[i];
                  if (null != playoff.team_fight.aka_team_id) {
                    playoff.team_fight.aka_team_name = $scope.teams_map[playoff.team_fight.aka_team_id].name;
                  }
                  if (null != playoff.team_fight.shiro_team_id) {
                    playoff.team_fight.shiro_team_name = $scope.teams_map[playoff.team_fight.shiro_team_id].name;
                  }
                }
              }

              var buildTreeBranch = function(root) {
                if (null != root.playoff_fight.previous_aka_fight_id) {
                  root.playoff_fight.previous_aka_fight = $scope.playoff_map[root.playoff_fight.previous_aka_fight_id];
                  buildTreeBranch(root.playoff_fight.previous_aka_fight);
                }
                if (null != root.playoff_fight.previous_shiro_fight_id) {
                  root.playoff_fight.previous_shiro_fight = $scope.playoff_map[root.playoff_fight.previous_shiro_fight_id];
                  buildTreeBranch(root.playoff_fight.previous_shiro_fight);
                }
              }

              var buildLeveledPlayoffTree = function(trunk) {
                var levelArray = [];
                var level = 0;
                if (null != trunk) {
                  buildLevelOfPlayoffTree(trunk, levelArray, level);
                }
                return levelArray;
              }

              var buildLevelOfPlayoffTree = function(trunk, levelArray, level) {
                if (null == levelArray[level]) {
                  levelArray.push([]);
                }
                levelArray[level].push(trunk);
                if (null != trunk.playoff_fight.previous_shiro_fight) {
                  buildLevelOfPlayoffTree(
                      trunk.playoff_fight.previous_shiro_fight, levelArray,
                      level + 1);
                }

                if (null != trunk.playoff_fight.previous_aka_fight) {
                  buildLevelOfPlayoffTree(
                      trunk.playoff_fight.previous_aka_fight, levelArray,
                      level + 1);
                }
              }

              var preparePlayoffTree = function() {
                if ($scope.teams && $scope.playoff_fights) {
                  buildTeamsMap();
                  buildPlayoffTree();
                }
              }

              if ($stateParams.tournamentId && ($state.is('tournaments_show') || $state.is('tournaments_edit'))) {
                if($state.is('tournaments_show')) {
                  getTournament($stateParams.tournamentId);
                  getGroups($stateParams.tournamentId);
                  getTeams($stateParams.tournamentId, preparePlayoffTree);
                  getParticipants($stateParams.tournamentId);
                  getPlayoffFights($stateParams.tournamentId, preparePlayoffTree);
                } else {
                  getTournament($stateParams.tournamentId);
                }
              } else {
                if($state.is('tournaments')) {
                  tournamentsResource.query(function(response) {
                    $scope.tournaments = response;
                  },  function(httpResponse) {
                    FlashingService.flashRestFailed("{{'GET' | translate}}",
                        "{{'TOURNAMENTS' | translate }}", httpResponse);
                    $scope.tournaments = null;
                  })
                }
                $scope.tournament = {};
                if($state.is('tournaments_new')) {
                  $scope.tournament.player_sex_constraint_value = "all_allowed";
                  $scope.tournament.player_age_constraint = 'age_no_constraint';
                  $scope.tournament.player_age_constraint_value = 0;
                  $scope.tournament.player_rank_constraint = 'rank_no_constraint';
                  $scope.tournament.player_rank_constraint_value = 'dan_1';
                }
              }

              $scope.save = function() {
                var onError = function(httpResponse) {
                  FlashingService.flashRestFailed("{{'SAVE' | translate}}",
                      "{{'TOURNAMENT' |translate}}", httpResponse);
                };

                if ($scope.tournament.id) {
                  tournamentsResource.save($scope.tournament, function() {
                    $state.go('tournaments_show', {
                      tournamentId : $scope.tournament.id
                    });
                  }, onError);
                } else {
                  tournamentsResource.create($scope.tournament, function(
                      newTournament) {
                    $state.go('tournaments_show', {
                      tournamentId : newTournament.id
                    });
                  }, onError);
                }
              };

              $scope["delete"] = function() {
                tournamentsResource.delete({tournamentId: $scope.tournament.id}, function(response) {
                  $state.go('home');
                });
              }

              $scope.signedIn = Auth.isAuthenticated;

              $scope.newTournament = function() {
                $state.go('tournaments_new');
              }

              $scope.edit = function() {
                $state.go('tournaments_edit',{tournamentId: $scope.tournament.id});
              };

              $scope.ageConstraints = [
                'age_no_constraint',
                'age_less_or_equal',
                'age_greater_or_equal',
                'age_equal'
              ]

              $scope.rankConstraints = [
                'rank_no_constraint',
                'rank_less_or_equal',
                'rank_greater_or_equal',
                'rank_equal'
              ]

              $scope.mapAgeConstraints = function(constraint) {
                switch(constraint) {
                  case 'age_no_constraint': return "-";
                  case 'age_less_or_equal': return "<=";
                  case 'age_greater_or_equal': return ">=";
                  case 'age_equal': return "==";
                  default: return constraint;
                }
              }

              $scope.mapRankConstraints = function(constraint) {
                switch(constraint) {
                  case 'rank_no_constraint': return "-";
                  case 'rank_less_or_equal': return "<=";
                  case 'rank_greater_or_equal': return ">=";
                  case 'rank_equal': return "==";
                  default: return constraint;
                }
              }

              $scope.ranks = [
                'kyu_6',
                'kyu_5',
                'kyu_4',
                'kyu_3',
                'kyu_2',
                'kyu_1',
                'dan_1',
                'dan_2',
                'dan_3',
                'dan_4',
                'dan_5',
                'dan_6',
                'dan_7',
                'dan_8'
              ];

              $scope.mapRanks = function(rank) {
                switch(rank) {
                  case "dan_8": return '8 DAN';
                  case "dan_7": return '7 DAN';
                  case "dan_6": return '6 DAN';
                  case "dan_5": return '5 DAN';
                  case "dan_4": return '4 DAN';
                  case "dan_3": return '3 DAN';
                  case "dan_2": return '2 DAN';
                  case "dan_1": return '1 DAN';
                  case "kyu_1": return '1 KYU';
                  case "kyu_2": return '2 KYU';
                  case "kyu_3": return '3 KYU';
                  case "kyu_4": return '4 KYU';
                  case "kyu_5": return '5 KYU';
                  case "kyu_6": return '6 KYU';
                  default: return rank;
                }
              }

              $scope.viewTournament = function(tournamentId) {
                $state.go('tournaments_show', {tournamentId: tournamentId});
              }
            } ]);