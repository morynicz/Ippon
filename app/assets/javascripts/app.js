angular.module('ippon',[
	'templates',
	'ui.router',
	'ngResource',
	'controllers',
]);

angular.module('ippon').config([
	'$stateProvider',
	'$urlRouterProvider',
	function($stateProvider, $urlRouterProvider) {

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
	  });

		$urlRouterProvider.otherwise('home');
	}]);

angular.module('controllers', ['ngResource', 'ui.router']);
