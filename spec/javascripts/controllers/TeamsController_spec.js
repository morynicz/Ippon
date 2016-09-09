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
  var fakeTournamentId = 33;

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

  var fakePlayers = [
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

  var state;

  var expectUnassignedTournamentPlayers = function(tournamentId, players) {
    httpBackend.expectGET(new RegExp("tournaments/" + tournamentId + "/participants/unassigned")).respond(players);
  }

  var expectGetTeam = function(teamId, isAdmin, team, players) {
    var request = new RegExp("teams/" + teamId);
    var responseComposite = {
      team: team,
      players: players,
      is_admin: isAdmin
    };
    responseComposite.team.id = teamId;
    httpBackend.expectGET(request).respond(200, responseComposite);
  };

  var expectTeamNotFound = function(teamId) {
    var request = new RegExp("teams/" + teamId);
    httpBackend.expectGET(request).respond(404, null);
  }

  var setupController = function(stateName, teamId) {
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

      if (teamId) {
        stateParams.teamId = teamId;
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
        setupController('teams_show', fakeTeamId);
        expectGetTeam(fakeTeamId, false, fakeTeam, [fakePlayer]);
      });
      it('loads the given team', function() {
        httpBackend.flush();
        expect(scope.team).toEqualData(fakeTeam);
        expect(scope.members).toEqualData([fakePlayer]);
        expect(scope.is_admin).toBe(false);
      });
    });

    describe('team is not found', function() {
      beforeEach(function() {
        setupController('teams_show', fakeTeamId);
        expectTeamNotFound(fakeTeamId);
      });
      it("doesn't load a team", function() {
        httpBackend.flush();
        expect(scope.team).toBe(null);
        expect(scope.members).toBe(null);
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
      setupController('teams_new', false);
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
      setupController('teams_edit', fakeTeamId);
      expectGetTeam(fakeTeamId, true, fakeTeam, [fakePlayer]);
      expectUnassignedTournamentPlayers(fakeTournamentId, fakePlayers);
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

      expect(scope.team.name).toBe(updatedTeam.name);
      expect(scope.team.required_size).toBe(updatedTeam.required_size);
      expect(angular.equals(scope.members, [fakePlayer])).toBe(true);
      expect(angular.equals(scope.players, players)).toBe(true);
    });
  });

  describe('delete', function() {
    beforeEach(function() {
      setupController('teams_show', fakeTeamId);
      expectGetTeam(fakeTeamId, true, fakeTeam, [fakePlayer]);
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

  describe('add_member', function() {
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
      },
      fakePlayer
    ];

    beforeEach(function() {
      setupController('teams_edit', fakeTeamId);
      expectGetTeam(fakeTeamId, false, fakeTeam, []);
      expectUnassignedTournamentPlayers(fakeTournamentId, players);
      httpBackend.flush();
      httpBackend.expectPUT(new RegExp("teams/" + fakeTeamId + "/add_member/" + fakePlayerId)).respond(204);
      expectGetTeam(fakeTeamId, true, fakeTeam, [fakePlayer]);
      expectUnassignedTournamentPlayers(fakeTournamentId, fakePlayers);
    });

    it('posts to the backend', function() {
        scope.add_member(fakePlayerId, true);
        httpBackend.flush();
        expect(state.is('teams_edit')).toBe(true);
        expect(scope.members).toContain(fakePlayer);
        expect(angular.equals(scope.members, [fakePlayer])).toBe(true);
        expect(angular.equals(scope.players, fakePlayers)).toBe(true);
    });
  });

  describe('delete_member', function() {
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
      },
      fakePlayer
    ];

    beforeEach(function() {
      setupController('teams_edit', fakeTeamId);
      expectGetTeam(fakeTeamId, true, fakeTeam, [fakePlayer]);
      expectUnassignedTournamentPlayers(fakeTournamentId, fakePlayers);
      httpBackend.flush();
      httpBackend.expectDELETE(new RegExp("teams/" + fakeTeamId + "/delete_member/" + fakePlayerId)).respond(204);
      expectGetTeam(fakeTeamId, true, fakeTeam, []);
      expectUnassignedTournamentPlayers(fakeTournamentId, players);
    });

    it('posts to the backend', function() {
        scope.delete_member(fakePlayerId, true);
        httpBackend.flush();
        expect(state.is('teams_edit')).toBe(true);
        expect(scope.members).not.toContain(fakePlayer);
        expect(angular.equals(scope.members, [])).toBe(true);
        expect(angular.equals(scope.players, players)).toBe(true);
    });
  });
});
