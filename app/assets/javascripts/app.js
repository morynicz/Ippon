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
		});;

		$urlRouterProvider.otherwise('home');

		$translateProvider.translations('en', {
			CLUBS: "Clubs",
			HOME: "Ippon Home Page",
			HOME_TEXT: "Here shall be some links",
			BUTTON_TEXT_EN: "English",
			BUTTON_TEXT_PL: "Polish"
		})
		.translations('pl', {
			CLUBS: "Kluby",
			HOME: "Strona domowa Ippon",
			HOME_TEXT: "Tu pojawią się linki",
			BUTTON_TEXT_EN: "Angielski",
			BUTTON_TEXT_PL: "Polski"
		});

		$translateProvider.useSanitizeValueStrategy('escape');
		$translateProvider.preferredLanguage('en');

	}]);
