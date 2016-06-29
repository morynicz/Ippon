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
    if($scope.player == null || $scope.player.clubId == null) {
      $scope.player = {};
    }
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

  $scope.viewPlayersClub = function(clubId) {
    $state.go('clubs_show',{clubId: $scope.player.club.id});
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
}]);
