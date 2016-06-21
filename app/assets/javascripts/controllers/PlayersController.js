angular.module('ippon').controller('PlayersController',[
  '$scope',
  '$stateParams',
  '$location',
  '$resource',
  '$state',
  'Auth',
function($scope, $stateParams, $location, $resource, $state, Auth){
  var controllerRoot = "/players/";
  var player = $resource(controllerRoot + ':playerId',
    {
      clubId: "@id",
      format: "json"
    }, {
      'save' : {
        method: 'PUT'
      },
      'create': {
        method: 'POST'
      }
    });

    if($state.is('players_show')) {
      if(!$stateParams.playerId) {
        $state.go('players');
      } else {
        player.get({
          playerId: $stateParams.playerId
        }, function(player) {
          $scope.player = player;
        }, function(httpResponse) {
          $scope.player = null;
          //flash.error = 'There is no club with Id + $routeParams.clubId'
        });
      }
    } else {
      if($state.is('players')){
        player.query(function(results) {
          return $scope.players = results;
        });
      }
      $scope.player = {};
    }

    $scope.save = function() {
    var onError = function(_httpResponse) {
      //TODO flash.error
    }

    if($scope.player.id) {
      $scope.player.$save((function() {
        $state.go('players_show',{playerId: $scope.player.id});
      }), onError)
    } else {
      player.create($scope.player, (function(newPlayer) {
        $state.go('players_show',{playerId: newPlayer.id});
      }), onError);
    }
  };
}]);
