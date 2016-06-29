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
      playerId: "@id",
      format: "json"
    }, {
      'save' : {
        method: 'PUT'
      },
      'create': {
        method: 'POST'
      }
    }
  );

  var club = $resource('/clubs/:clubId',
    {
      clubId: "@id",
      format: "json"
    }
  );

    if($state.is('players_show') || $state.is('players_edit')) {
      if(!$stateParams.playerId) {
        $state.go('players');
      } else {
        player.get({
          playerId: $stateParams.playerId
        }, function(player) {
          $scope.player = player;
          club.get({clubId: player.club_id}, function(club) {
            $scope.player.club = club;
          });
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

    if($state.is('players_edit') || $state.is('players_new')) {
      club.query(function(results) {
        return $scope.clubs = results;
      });
    }

    $scope.index = function() {
      $state.go('players');
    }


  $scope.view = function(playerId) {
    $state.go("players_show",{playerId: playerId})
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

  $scope["delete"] = function() {
    $scope.player.$delete();
    $scope.index();
  }
}]);
