describe('ClubsController', function() {
  var scope = null;
  var ctrl = null;
  var location = null;
  var routeParams = null;
  var resource = null;

  var httpBackend = null;

  var setupController = function(results) {
    return inject(function($location, $routeParams, $rootScope, $resource, $httpBackend, $controller) {
      scope = $rootScope.$new();
      location = $location;
      resource = $resource;
      routeParams = $routeParams;
      httpBackend = $httpBackend;

      if(results) {
        var request = new RegExp("clubs");
        httpBackend.expectGET(request).respond(results);
      }

      ctrl = $controller('ClubsController', {
        $scope: scope,
        $location: location
      });

    });
  };

  beforeEach(module('ippon'));

  afterEach(function(){
    httpBackend.verifyNoOutstandingExpectation();
    httpBackend.verifyNoOutstandingRequest();
  });

  describe('index', function(){
    var clubs = [
      {
        id: 2,
        name: 'Ryushinkai',
        city: 'Wrocław',
        description: 'Najlepszy klub'
      },
      {
        id: 7,
        name: 'Nowoklub',
        city: 'Daleków',
        description: 'Świeżaki'
      }
    ];

    beforeEach(function(){
      setupController(clubs);
      httpBackend.flush();
    });
    it('calls the back-end', function() {
      expect(scope.clubs).toEqualData(clubs);
    });
  });
});
