angular.module('ippon',[
	'templates',
	'ngRoute',
	'ngResource',
	'controllers',
]);

angular.module('ippon').config([
	'$routeProvider',
	function($routeProvider) {

	  $routeProvider.when('/', {
	    templateUrl: 'Home/_index.html',
	    controller: 'HomePageController'
	  })
	  .when('/clubs', {
	    templateUrl: 'Clubs/_index.html',
	    controller: 'ClubsController'
	  })
	  .when('/clubs/:clubId', {
	    templateUrl: 'Clubs/_show.html',
	    controller: 'ClubsController'
	  })
	}]);

angular.module('controllers', ['ngResource']);
