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
    ;

		$urlRouterProvider.otherwise('home');

		$translateProvider.translations('en', {
			CLUBS: "Clubs",
			HOME: "Home Page",

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
			CLUB_DESCRIPTION_PLACEHOLDER: "Strongest club around"
		});

		$translateProvider.useStaticFilesLoader({
			prefix: "/i18n/locale-",
			suffix: ".json"
		});

		$translateProvider.useSanitizeValueStrategy('escape');
		$translateProvider.preferredLanguage('en');

	}]);
