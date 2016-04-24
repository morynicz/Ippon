describe('ClubsController', function() {
  var scope = null;
  var ctrl = null;
  var location = null;
  var routeParams = null;
  var resource = null;
  var httpBackend = null;
  var clubId = 42;

  var fakeClub = {
    id: clubId,
    name: "FakinClub",
    city: "Fakeville",
    description: "They are far from being real"
  };

  var setupController = function(clubExists, clubId, results) {
    return inject(function($location, $routeParams, $rootScope, $resource, $httpBackend, $controller) {
      scope = $rootScope.$new();
      location = $location;
      resource = $resource;
      routeParams = $routeParams;
      httpBackend = $httpBackend;

      var request = null;

      if(results) {
        request = new RegExp("clubs");
        httpBackend.expectGET(request).respond(results);
      } else if (clubId) {
        routeParams.clubId = clubId;
        request = new RegExp("clubs/" + clubId);
        results = (clubExists)?[200, fakeClub]:[404];
        httpBackend.expectGET(request).respond(results[0], results[1]);
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
      setupController(false,false,clubs);
      httpBackend.flush();
    });
    it('calls the back-end', function() {
      expect(scope.clubs).toEqualData(clubs);
    });
  });

  describe('show',function(){
    describe('club is found', function() {
      beforeEach(setupController(true,42,false));
      it('loads the given club', function() {
        httpBackend.flush();
        expect(scope.club).toEqualData(fakeClub);
      });
    });

    describe('club is not found', function() {
      beforeEach(setupController(false,42,false));
      it('loads given club', function() {
        httpBackend.flush();
        expect(scope.club).toBe(null);
        //flash about error
      });
    });
  });
});
