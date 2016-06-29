angular.module('ippon',[
	'templates',
	'ui.router',
	'ngResource',
	'Devise',
	'pascalprecht.translate'
]);

angular.module('ippon').config([
	'$stateProvider',
	'$urlRouterProvider',
	'$translateProvider',
	function($stateProvider, $urlRouterProvider, $translateProvider) {
		$stateProvider.state('home',{
			url: '/home',
			templateUrl: 'Home/_index.html',
			controller: 'HomePageController'
		})
    .state('login',{
      url: '/login',
      templateUrl: 'auth/_login.html',
      controller: 'AuthController',
      onEnter: ['$state', 'Auth', function($state, Auth) {
        Auth.currentUser().then(function() {
          $state.go('home');
        });
      }]
    })
    .state('register', {
      url: '/register',
      templateUrl: 'auth/_register.html',
      controller: 'AuthController'
    })
		.state('clubs', {
			url: '/clubs',
			templateUrl: 'Clubs/_index.html',
			controller: 'ClubsController'
		})
		.state('clubs_new',{
			url: '/clubs/new',
			templateUrl: 'Clubs/_form.html',
			controller: 'ClubsController'
		})
		.state('clubs_show',{
			url: '/clubs/:clubId',
			templateUrl: 'Clubs/_show.html',
			controller: 'ClubsController'
		})
		.state('clubs_edit', {
			url: '/clubs/:clubId/edit',
			templateUrl: 'Clubs/_form.html',
			controller: 'ClubsController'
		})
    .state('players', {
      url: '/players',
      templateUrl: 'Players/_index.html',
      controller: 'PlayersController'
    })
    .state('players_new',{
      url: '/players/new',
      templateUrl: 'Players/_form.html',
      controller: 'PlayersController'
    })
    .state('players_show',{
      url: '/players/:playerId',
      templateUrl: 'Players/_show.html',
      controller: 'PlayersController'
    })
    .state('players_edit', {
      url: '/players/:playerId/edit',
      templateUrl: 'Players/_form.html',
      controller: 'PlayersController'
    });

		$urlRouterProvider.otherwise('home');

		$translateProvider.translations('en', {
			HOME: "Home Page",
      CLUBS: "Clubs",
      PLAYERS: "Players",

			LANGUAGE: "Language",

			LOG_IN: "Log In",
			REGISTER: "Register",
			LOG_OUT: "Log Out",

			ADD: "Add",
			EDIT: "Edit",
			DELETE: "Delete",
			CANCEL: "Cancel",
			SAVE: "Save",
			INDEX: "Index",

			HOME_TITLE: "Ippon Home Page",
			HOME_TEXT: "Here shall be some links",

			AUTH_EMAIL: "Email",
			AUTH_USERNAME: "Username",
			AUTH_PASSWORD: "Password",

			CLUB_NAME: "Name",
			CLUB_NAME_PLACEHOLDER: "Osoms",
			CLUB_CITY: "City",
			CLUB_CITY_PLACEHOLDER: "Samuraiville",
			CLUB_DESCRIPTION: "Description",
			CLUB_DESCRIPTION_PLACEHOLDER: "Strongest club around",

      PLAYER_NAME: "Name",
      PLAYER_SURNAME: "Surname",
      PLAYER_AGE: "Age",
      PLAYER_BIRTHDAY: "Birthday",
      PLAYER_RANK: "Rank",
      PLAYER_SEX: "Sex",
      PLAYER_CLUB: "Club"
		});

		$translateProvider.useStaticFilesLoader({
			prefix: "/i18n/locale-",
			suffix: ".json"
		});

		$translateProvider.useSanitizeValueStrategy('escape');
		$translateProvider.preferredLanguage('en');

	}]);
