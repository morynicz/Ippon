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
        url: '/teams/:teamId/add_member/:playerId'
      },
      'delete_member' : {
        method: 'DELETE',
        url: '/teams/:teamId/delete_member/:playerId'
      }
    });

    var playerResource = $resource("/players/:playerId",
    {
      playerId: "@id",
      format: "json"
    });

    if($stateParams.teamId && ($state.is('teams_show') || $state.is('teams_edit'))) {
      teamResource.get({
        teamId: $stateParams.teamId
      }, function(response) {
        $scope.team = response.team;
        $scope.players = response.players;
        $scope.is_admin = response.is_admin;
      }, function(httpResponse) {
        $scope.team = null;
        $scope.players = null;
        $scope.is_admin = false;
      });
      if($state.is('teams_edit')) {
        playerResource.qery(function(results) {
          $scope.players = results;
        }, function(httpResponse) {
          $scope.players = null;
        });
      }
    } else {
      $scope.team={};
      $scope.tournament_id = $stateParams.tournament_id;
    }
  }]);
