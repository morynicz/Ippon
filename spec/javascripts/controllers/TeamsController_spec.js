describe('TeamsController', function() {
  var scope = null;
  var ctrl = null;
  var location = null;
  var stateParams = null;
  var resource = null;
  var httpBackend = null;
  var fakePlayerId = 42;
  var fakeClubId = 77;
  var fakeTeamId = 17;

  var fakePlayer = {
      "id": fakePlayerId,
      "name":"Tia",
      "surname":"Pollich",
      "birthday":"1994-07-26",
      "rank":"dan_4",
      "sex":"female",
      "club_id": fakeClubId
  };

  var fakeTeam = {
    id: fakeTeamId,
    name: "Team Name",
    required_size: 2,
    tournament_id: 33
  };

  var state;

  var setupController = function(teamExists, teamId, isAdmin, stateName) {
    return inject(function($location, $stateParams, $rootScope, $resource, $httpBackend, $controller, $state, $templateCache) {
      scope = $rootScope.$new();
      location = $location;
      resource = $resource;
      stateParams = $stateParams;
      httpBackend = $httpBackend;

      state = $state;

      $templateCache.put('Teams/_show.html','');
      $templateCache.put('Teams/_form.html','');

      state.go(stateName);
      $rootScope.$apply();
      var request = null;

      if(isAdmin === null) {
        isAdmin = false;
      }

      if (teamId) {
        stateParams.teamId = teamId;
        request = new RegExp("teams/" + teamId);
        var responseComposite = {
          team: fakeTeam,
          players: [
            fakePlayer
          ],
          is_admin: isAdmin
        };
        responseComposite.team.id = teamId;
        var results = (teamExists)?[200, responseComposite]:[404];
        httpBackend.expectGET(request).respond(results[0], results[1]);
      }

      ctrl = $controller('TeamsController', {
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

  describe('show',function(){
    describe('team is found', function() {
      beforeEach(function() {
        setupController(true,fakeTeamId,false,'teams_show');
      });
      it('loads the given team', function() {
        httpBackend.flush();
        expect(scope.team).toEqualData(fakeTeam);
        expect(scope.players).toEqualData([fakePlayer]);
        expect(scope.is_admin).toBe(false);
      });
    });

    describe('team is not found', function() {
      beforeEach(setupController(false, fakeTeamId,false,'teams_show'));
      it("doesn't load a team", function() {
        httpBackend.flush();
        expect(scope.team).toBe(null);
        expect(scope.players).toBe(null);
        expect(scope.is_admin).toBe(false);
        //flash about error
      });
    });
  });

  describe('create', function() {
    var newTeam = {
      name: "Teemo",
      required_size: 3,
      tournament_id: 15
    };

    beforeEach(function() {
      setupController(false, false, false, 'teams_new');
      var request = new RegExp("\/teams");
      httpBackend.expectPOST(request).respond(201, newTeam);
    });

    it('post to the backend', function() {
      scope.team.name = newTeam.name;
      scope.team.required_size = newTeam.required_size;
      scope.team.tournament_id = newTeam.tournament_id;

      scope.save();
      scope.$apply();
      httpBackend.flush();
      expect('#' + location.path()).toBe(state.href('teams_show'));
      expect(state.is('teams_show')).toBe(true);
    });
  });

  describe('update', function() {
    var updatedTeam = {
      name: "Teleteam",
      required_size: 4
    };

    var players = [
      {
        "id":71,
        "name":"Tessie",
        "surname":"Ryan",
        "birthday":"1979-04-28",
        "rank":"kyu_3",
        "sex":"male",
        "club_id":71
      },
      {
        "id":72,
        "name":"Elza",
        "surname":"Spinka",
        "birthday":"1982-01-22",
        "rank":"dan_1",
        "sex":"male",
        "club_id":72
      }];

    beforeEach(function() {
      setupController(true, fakeTeamId,false,'teams_edit');
      httpBackend.expectGET(new RegExp("players")).respond(players);
      httpBackend.flush();
      var request = new RegExp("teams/");
      httpBackend.expectPUT(request).respond(204);
    });

    it('posts to the backend', function() {
      scope.team.name = updatedTeam.name;
      scope.team.required_size = updatedTeam.required_size;
      scope.save();
      httpBackend.flush();
      expect('#'+location.path()).toBe(state.href('teams_show',{teamId: scope.team.id}));
      expect(state.is('teams_show')).toBe(true);
    });
  });

  describe('delete', function() {
    beforeEach(function() {
      setupController(true,fakeTeamId,false,'teams_show');
      httpBackend.flush();
      var request = new RegExp("teams/" + scope.team.id);
      httpBackend.expectDELETE(request).respond(204);
    });

    it('posts to the backend', function() {
      scope["delete"]();
      scope.$apply();
      httpBackend.flush();
      expect('#'+ location.path()).toBe(state.href('home'));
    });
  });
});
