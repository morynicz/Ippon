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

              var tournamentResource = $resource("tournaments/:tournamentId", {
                tournamentId : "@id",
                format : "json"
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
                tournamentResource.get({
                  tournamentId : tournamentId
                }, function(response) {
                  $scope.tournament = response;
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

              if ($stateParams.tournamentId && $state.is('tournaments_show')) {
                getTournament($stateParams.tournamentId);
                getGroups($stateParams.tournamentId);
                getTeams($stateParams.tournamentId, preparePlayoffTree);
                getParticipants($stateParams.tournamentId);
                getPlayoffFights($stateParams.tournamentId, preparePlayoffTree);
              }
            } ]);