angular.module('ippon').controller('ClubsController',[
  '$scope',
  '$stateParams',
  '$location',
  '$resource',
  '$state',
function($scope, $stateParams, $location, $resource, $state){
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



  if($state.is('clubs_show') || $state.is('clubs_edit')) {
    if(!$stateParams.clubId) {
      $state.go('clubs');
    } else {
      club.get({
        clubId: $stateParams.clubId
      }, function(club) {
        $scope.club = club;
      }, function(httpResponse) {
        $scope.club = null;
        //flash.error = 'There is no club with Id + $routeParams.clubId'
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
//    $location.path(controllerRoot);
    $state.go('clubs');
  }

  $scope.newClub = function(recipeId) {
    //$location.path(controllerRoot +"new");
    $state.go('clubs_new');
  }

  $scope.view = function(clubId) {
    //return $location.path(controllerRoot + clubId);
    $state.go('clubs_show',{clubId: clubId});
  }

  $scope.edit = function() {
    //$location.path(controllerRoot + $scope.club.id + "/edit");
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
      //TODO flash.error
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
}]);
