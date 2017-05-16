describe('PlayersController', function() {
  var scope = null;
  var ctrl = null;
  var location = null;
  var stateParams = null;
  var resource = null;
  var httpBackend = null;
  var fakePlayerId = 42;
  var fakeClubId = 77;
  var state;

  var fakePlayer = {
      "id": fakePlayerId,
      "name":"Tia",
      "surname":"Pollich",
      "birthday":"1994-07-26",
      "rank":"dan_4",
      "sex":"female",
      "club_id": fakeClubId
  }

  var fakeClub = {
    id: fakeClubId,
    name: "FakinClub",
    city: "Fakeville",
    description: "They are far from being real"
  };

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

  var setupController = function(playerExists, playerId, results, stateName, stateData = null) {
    return inject(function($location, $stateParams, $rootScope, $resource, $httpBackend, $controller, $state, $templateCache) {
      scope = $rootScope.$new();
      location = $location;
      resource = $resource;
      stateParams = $stateParams;
      httpBackend = $httpBackend;

      state = $state;

      $templateCache.put('Players/_index.html','');
      $templateCache.put('Players/_show.html','');
      $templateCache.put('Players/_form.html','');

      if(stateData) {
        state.go(stateName, stateData);
      } else {
        state.go(stateName);
      }
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

  var setupClub = function(clubId, club) {
    var request = new RegExp("clubs/" + clubId);
    var results = [200, club];
    httpBackend.expectGET(request).respond(results[0], results[1]);
  };

  var setupClubs = function(clubs) {
    var request = new RegExp("clubs");
    var results = [200, clubs];
    httpBackend.expectGET(request).respond(results[0], results[1]);
  };

  var setupIsAdminForClub = function(clubId, isAdmin) {
    var request = new RegExp("clubs/admin/"+clubId);
    var results = [200, isAdmin];
    httpBackend.expectGET(request).respond(results[0], results[1]);
  };

  var setupIsClubAdmin = function(isAdmin) {
    var request = new RegExp("clubs/admin/any");
    var results = [200, isAdmin];
    httpBackend.expectGET(request).respond(results[0], results[1]);
  };

  describe('index', function(){
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
      },{
        "id":73,
        "name":"Ines",
        "surname":"Hirthe",
        "birthday":"1970-04-18",
        "rank":"kyu_3",
        "sex":"male",
        "club_id":73
      },
      {
        "id":74,
        "name":"Isac",
        "surname":"Fritsch",
        "birthday":"1957-09-06",
        "rank":"dan_1",
        "sex":"female",
        "club_id":74
      },
      {
        "id":75,
        "name":"Trenton",
        "surname":"Denesik",
        "birthday":"1990-05-04",
        "rank":"dan_2",
        "sex":"female",
        "club_id":75
      },
      {
        "id":76,
        "name":"Karlee",
        "surname":"Kuhic",
        "birthday":"1965-12-10",
        "rank":"kyu_5",
        "sex":"female",
        "club_id":76
      }];

    beforeEach(function(){
      setupController(false,false,players,'players');
      setupIsClubAdmin(false);
      httpBackend.flush();
    });
    it('calls the back-end', function() {
      expect(scope.players).toEqualData(players);
    });
  });

  describe('show',function(){
    describe('player is found', function() {
      beforeEach(function() {
        setupController(true,fakePlayerId,false,'players_show', {playerId: fakePlayerId});
        setupClub(fakeClubId,fakeClub);
        setupIsAdminForClub(fakeClubId, false)
      });
      it('loads the given player', function() {
        httpBackend.flush();
        var composedPlayer = fakePlayer;
        composedPlayer.club = fakeClub;

        expect(scope.player.name).toEqualData(composedPlayer.name);
        expect(scope.player.surname).toEqualData(composedPlayer.surname);
        expect(scope.player.sex).toEqualData(composedPlayer.sex);
        expect(scope.player.rank).toEqualData(composedPlayer.rank);
        expect(scope.player.club).toEqualData(composedPlayer.club);
        expect(scope.player.club_id).toEqualData(composedPlayer.club_id);
      });
    });

    describe('player is not found', function() {
      beforeEach(setupController(false, fakePlayerId,false,'players_show'),  {playerId: fakePlayerId});
      it("doesn't load a player", function() {
        httpBackend.flush();
        expect(scope.player).toBe(null);
        //flash about error
      });
    });
  });

  describe('create', function() {
    var newPlayer = {
      id: 104,
      name: "Steve",
      surname: "Balistreri",
      birthday: "1960-10-06",
      rank: "dan_7",
      sex: "male",
      club_id: 120
    };

    beforeEach(function() {
      setupController(false, false, false, 'players_new');
      setupClubs(clubs);
      var request = new RegExp("\/players");
      httpBackend.expectPOST(request).respond(201, newPlayer);
    });

    it('post to the backend', function() {
      scope.player.name = newPlayer.name;
      scope.player.surname = newPlayer.surname;
      scope.player.birthday = newPlayer.birthday;
      scope.player.rank = newPlayer.rank;
      scope.player.sex = newPlayer.sex;
      scope.player.club_id = newPlayer.club_id;

      scope.save();
      scope.$apply();
      httpBackend.flush();
      expect('#' + location.path()).toBe(state.href('players_show'));
      expect(state.is('players_show')).toBe(true);
    });
  });

  describe('update', function() {
    var updatedPlayer = {
      id: 97,
      name: "Misael",
      surname: "Durgan",
      birthday: "1978-02-28",
      rank: "kyu_2",
      sex: "male",
      club_id: 113
    };

    beforeEach(function() {
      setupController(true, fakePlayerId,false,'players_edit',  {playerId: fakePlayerId});
      setupClubs(clubs);
      setupClub(fakeClubId, fakeClub);
      httpBackend.flush();
      var request = new RegExp("players/");
      httpBackend.expectPUT(request).respond(204);
    });

    it('posts to the backend', function() {
      scope.player.name = updatedPlayer.name;
      scope.player.surname = updatedPlayer.surname;
      scope.player.birthday = updatedPlayer.birthday;
      scope.player.rank = updatedPlayer.rank;
      scope.player.sex = updatedPlayer.sex;
      scope.player.club_id = updatedPlayer.club_id;
      scope.save();
      httpBackend.flush();
      expect('#'+location.path()).toBe(state.href('players_show',{playerId: scope.player.id}));
      expect(state.is('players_show')).toBe(true);
    });
  });

  describe('delete', function() {
    beforeEach(function() {
      setupController(true,fakePlayerId,false,'players_show',  {playerId: fakePlayerId});
      setupClub(fakeClubId,fakeClub);
      setupIsAdminForClub(fakeClubId, true)
      httpBackend.flush();
      var request = new RegExp("players/" + scope.player.id);
      httpBackend.expectDELETE(request).respond(204);
    });

    it('posts to the backend', function() {
      scope["delete"]();
      scope.$apply();
      httpBackend.flush();
      expect('#'+ location.path()).toBe(state.href('players'));
    });
  });
});
