describe('PlayersController', function() {
  var scope = null;
  var ctrl = null;
  var location = null;
  var stateParams = null;
  var resource = null;
  var httpBackend = null;
  var playerId = 42;
  var state;

  var fakePlayer = {
      "id": playerId,
      "name":"Tia",
      "surname":"Pollich",
      "birthday":"1994-07-26",
      "rank":"dan_4",
      "sex":"female",
      "club_id":77
  }

  var setupController = function(playerExists, playerId, results, stateName) {
    return inject(function($location, $stateParams, $rootScope, $resource, $httpBackend, $controller, $state, $templateCache) {
      scope = $rootScope.$new();
      location = $location;
      resource = $resource;
      stateParams = $stateParams;
      httpBackend = $httpBackend;

      state = $state;

      //$templateCache.put('Clubs/_index.html','');
      //$templateCache.put('Clubs/_show.html','');
      //$templateCache.put('Clubs/_form.html','');

      state.go(stateName);
      $rootScope.$apply();
      var request = null;

      if(results) {
        request = new RegExp("players");
        httpBackend.expectGET(request).respond(results);
      } else if (playerId) {
        stateParams.playerId = playerId;
        request = new RegExp("players/" + playerId);
        results = (playerExists)?[200, fakePlayer]:[404];
        httpBackend.expectGET(request).respond(results[0], results[1]);
      }

      ctrl = $controller('PlayersController', {
        $scope: scope,
        $location: location,
        $state: state
      });
    });
  };

  beforeEach(module('ippon'));

  afterEach(function(){
    httpBackend.verifyNoOutstandingExpectation();
    httpBackend.verifyNoOutstandingRequest();
  });

});
