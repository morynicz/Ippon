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
  var fakeTeam = {
    id: fakeTeamId,
    name: "Team Name",
    required_size: 2,
  }
  var responseComposite = {
    team: fakeTeam,
    players = [
      fakePlayer
    ],
    is_admin: false
  }
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
          players = [
            fakePlayer
          ],
          is_admin: isAdmin
        }
        responseComposite.team.id = teamId;
        results = (teamExists)?[200, fakeTeam]:[404];
        httpBackend.expectGET(request).respond(results[0], results[1]);
      }

      ctrl = $controller('TeamsController', {
        $scope: scope,
        $location: location,
        $state: state
      });
    });

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
          var composedExpecataion = {};
          composedExpecataion.team = fakeTeam;
          composedExpecataion.players = [fakePlayer];
          composedExpecataion.is_admin = false;
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
});
