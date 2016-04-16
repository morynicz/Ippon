angular.module('controllers').controller('ClubsController',['$scope','$routeParams','$location','$resource',
function($scope,$routeParams,$location,$resource){
  var club = $resource('clubs/:clubId', {clubId: "@id", format: "json"});

  club.query(function(results) {
    return $scope.clubs = results;
  });

}]);
