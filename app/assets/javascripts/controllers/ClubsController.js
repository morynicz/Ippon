angular.module('controllers').controller('ClubsController',['$scope','$routeParams','$location','$resource',
function($scope,$routeParams,$location,$resource){
  var controllerRoot = "/clubs/";
  var club = $resource(controllerRoot + ':clubId',
    {
      clubId: "@id",
      format: "json"
    });



  if($routeParams.clubId) {
    club.get({
      clubId: $routeParams.clubId
    }, function(club) {
      $scope.club = club;
    }, function(httpResponse) {
      $scope.club = null;
      //flash.error = 'There is no club with Id + $routeParams.clubId'
    });
  } else {
    $scope.club = {};
    club.query(function(results) {
      return $scope.clubs = results;
    });
  }

  $scope.view = function(clubId) {
    return $location.path(controllerRoot + clubId);
  }

  $scope.edit = function() {
    $location.path(controllerRoot + $scope.club.id + "/edit");
  };

  $scope.cancel = function() {
    if($scope.club.id) {
      $location.path(controllerRoot + $scope.club.id);
    } else {
      $location.path(controllerRoot);
    }
  };

}]);
