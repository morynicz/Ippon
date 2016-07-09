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

  var adminedClub = $resource('/clubs/admin/:clubId',
    {
      format: "json",
    },
    {
      'admin_for_any':
      {
        method: "GET",
        isArray: false,
        url: '/clubs/admin/any'
      },
      'is_admin':
      {
        metod: "GET",
        isArray: false,
        params: {
          clubId: "@clubId"
        }
      }
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
        $scope.player.birthday = new Date($scope.player.birthday);
        club.get({clubId: player.club_id}, function(club) {
          $scope.player.club = club;
        });

        if($state.is('players_show')) {
          adminedClub.is_admin({clubId: player.club_id}, function(admin) {
            $scope.isAdmin = admin;
          });
        }
      }, function(httpResponse) {
        $scope.player = null;
        //flash.error = 'There is no club with Id + $routeParams.clubId'
      });
    }
  } else {
    if($state.is('players')){
      player.query(function(results) {
        $scope.players = results;
      });
      $scope.isAdmin = false;
      adminedClub.admin_for_any(function(admin) {
        $scope.isAdmin = admin.is_admin;
      });
    }
    $scope.player = {};
    if($stateParams.club_id != null) {
      $scope.player.club_id = $stateParams.club_id;
    }
  }

  if($state.is('players_edit')) {
    club.query(function(results) {
      $scope.clubs = results;
    });
  } else if($state.is('players_new')){
    adminedClub.query(function(results) {
      $scope.clubs = results;
    });
  }

  $scope.index = function() {
    $state.go('players');
  }

  $scope.newPlayer = function() {
    $state.go('players_new');
  }

  $scope.view = function(playerId) {
    $state.go("players_show",{playerId: playerId})
  }

  $scope.edit = function() {
    $state.go('players_edit',{playerId: $scope.player.id});
  };

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

  $scope.cancel = function() {
    if($scope.player.id) {
      $state.go('players_show',{playerId: $scope.player.id});
    } else {
      $state.go('players');
    }
  };

  $scope["delete"] = function() {
    $scope.player.$delete();
    $scope.index();
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
}]);
