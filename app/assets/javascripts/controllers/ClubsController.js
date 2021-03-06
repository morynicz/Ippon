angular.module('ippon').controller('ClubsController',[
  '$scope',
  '$stateParams',
  '$location',
  '$resource',
  '$state',
  'Auth',
  'FlashingService',
function($scope, $stateParams, $location, $resource, $state, Auth, FlashingService){
  var controllerRoot = "/clubs/";
  var club = $resource(controllerRoot + ':clubId',
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
  var admins = $resource(controllerRoot + ':clubId' + '/admins/' + ':adminId',
    {
      clubId: "@clubId",
      format: "json"
    },{
      'query_admins' : {
        method: 'GET',
        isArray: false
      },
      'create' : {
        method: 'POST',
        params: {
          clubId: "@clubId",
          adminId: "@adminId"
        }
      },
      'delete' : {
        method: 'DELETE',
        params: {
          clubId: "@clubId",
          adminId: "@adminId"
        }
      }
    });

  var player = $resource(controllerRoot + ":clubId" + "/players/" + ":playerId",
    {
      clubId: "@Id",
      format: "json"
    });

  if($state.is('clubs_show') || $state.is('clubs_edit')) {
    if(!$stateParams.clubId) {
      $state.go('clubs');
    } else {
      club.get({
        clubId: $stateParams.clubId
      }, function(club) {
        $scope.club = club;
        if ($state.is('clubs_show')) {
          player.query({clubId: $stateParams.clubId},
          function(results) {
            $scope.players = results;
          });
          admins.query_admins({clubId: $stateParams.clubId},
            function(results) {
              $scope.admins = results.admins;
              $scope.users = results.users;
            }
          );
        }
      }, function(httpResponse) {
        $scope.club = null;
        FlashingService.flashRestFailed("{{'FIND' | translate}}",
          "{{'CLUB'  |translate}}", httpResponse);
      });

    }
  } else {
    if($state.is('clubs')){
      club.query(function(results) {
        return $scope.clubs = results;
      });
    }
    $scope.club = {};
  }

  $scope.index = function() {
    $state.go('clubs');
  }

  $scope.newClub = function(recipeId) {
    $state.go('clubs_new');
  }

  $scope.view = function(clubId) {
    $state.go('clubs_show',{clubId: clubId});
  }

  $scope.edit = function() {
    $state.go('clubs_edit',{clubId: $scope.club.id});
  };

  $scope.cancel = function() {
    if($scope.club.id) {
      $state.go('clubs_show',{clubId: $scope.club.id});
    } else {
      $state.go('clubs');
    }
  };

  $scope.save = function() {
    var onError = function(_httpResponse) {
      FlashingService.flashRestFailed("{{'SAVE' | translate}}",
        "{{'CLUB'  |translate}}", _httpResponse);
    }

    if($scope.club.id) {
      $scope.club.$save((function() {
        $state.go('clubs_show',{clubId: $scope.club.id});
      }), onError)
    } else {
      club.create($scope.club, (function(newClub) {
        $state.go('clubs_show',{clubId: newClub.id});
      }), onError);
    }
  };

  $scope["delete"] = function() {
    $scope.club.$delete();
    $scope.index();
  }

  $scope.signedIn = Auth.isAuthenticated;

  $scope.addAdmin = function(userId) {
    admins.create(
      {
        adminId: userId,
        clubId: $scope.club.id
      },function(result) {
        admins.query_admins({clubId: $stateParams.clubId},
          function(results) {
            $scope.admins = results.admins;
            $scope.users = results.users;
          });
      }, function(httpResponse) {
        FlashingService.flashRestFailed("{{'SAVE' | translate}}",
          "{{'CLUB' |translate}}", httpResponse);
      });

  }

  $scope.deleteAdmin = function(userId) {
    admins.delete({
      adminId: userId,
      clubId: $scope.club.id
    }, function(result){
      admins.query_admins({clubId: $stateParams.clubId},
        function(results) {
          $scope.admins = results.admins;
          $scope.users = results.users;
        });
    }, function(httpResponse) {
      FlashingService.flashRestFailed("{{'DELETE' | translate}}",
        "{{'CLUB' |translate}}", httpResponse);
    });

  }

  $scope.viewPlayer = function(playerId) {
    $state.go("players_show",{playerId: playerId});
  }

  $scope.addPlayer = function() {
    $scope.player = {};
    $scope.player.club_id = $scope.club.id;
    $state.go('players_new',{club_id: $scope.club.id});
  }
}]);
