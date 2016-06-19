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

    if($state.is('players')){
      player.query(function(results) {
        return $scope.players = results;
      });
    }
}]);
