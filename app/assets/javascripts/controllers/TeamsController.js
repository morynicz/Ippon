angular.module('ippon').controller('TeamsController',[
  '$scope',
  '$stateParams',
  '$location',
  '$resource',
  '$state',
  'Auth',
  function($scope, $stateParams, $location, $resource, $state, Auth){

    var teamResource = $resource("/teams/:teamId",
    {
      teamId: "@id",
      format: "json"
    }, {
      'save': {
        method: 'PUT'
      },
      'create': {
        method: 'POST'
      },
      'add_member' : {
        method: 'PUT',
        url: '/teams/:teamId/add_member/:playerId',
        params: {
          teamId: "@teamId",
          playerId: "@playerId"
        }
      },
      'delete_member' : {
        method: 'DELETE',
        url: '/teams/:teamId/delete_member/:playerId'
      }
    });

    var getTeam = function(teamId) {
      teamResource.get({
        teamId: teamId
      }, function(response) {
        $scope.team = response.team;
        $scope.members = response.players;
        $scope.is_admin = response.is_admin;
      }, function(httpResponse) {
        $scope.team = null;
        $scope.members = null;
        $scope.is_admin = false;
      });
    }

    var playerResource = $resource("/players/:playerId",
    {
      playerId: "@id",
      format: "json"
    });

    if($stateParams.teamId && ($state.is('teams_show') || $state.is('teams_edit'))) {
      getTeam($stateParams.teamId);
      if($state.is('teams_edit')) {
        playerResource.query(function(results) {
          $scope.players = results;
        }, function(httpResponse) {
          $scope.players = null;
        });
      }
    } else {
      $scope.team = {};
      $scope.tournament_id = $stateParams.tournament_id;
    }

    $scope.save = function() {
      var onError = function(_httpResponse) {
        //TODO flash.error
      };

      if($scope.team.id) {
        teamResource.save($scope.team, function() {
          $state.go('teams_show',{teamId: $scope.team.id});
        }, onError);
      } else {
        teamResource.create($scope.team, function(newTeam) {
          $state.go('teams_show',{teamId: newTeam.id});
        }, onError);
      }
    };

    $scope["delete"] = function() {
      teamResource.delete({teamId: $scope.team.id});
      $state.go('home');
    }

    $scope.add_member = function(playerId) {
      teamResource.add_member({teamId: $scope.team.id, playerId: playerId},
      function() {
        getTeam($scope.team.id);
      });
    };

    $scope.delete_member = function(playerId) {
      teamResource.delete_member({teamId: $scope.team.id, playerId: playerId},
      function() {
        getTeam($scope.team.id);
      });
    };

    $scope.edit = function() {
      $state.go('teams_edit',{teamId: $scope.team.id});
    };

    $scope.cancel = function() {
      if($scope.player.id) {
        $state.go('teams_show',{teamId: $scope.team.id});
      } else {
        $state.go('teams');
      }
    };
  }]);
