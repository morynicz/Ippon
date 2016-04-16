angular.module('ippon',['templates', 'ngRoute', 'ngResource', 'controllers']);

angular.module('ippon').config(['$routeProvider',
function($routeProvider) {
  $routeProvider.when('/', {
    templateUrl: 'Home/_index.html',
    controller: 'HomePageController'
  });
}]);

angular.module('controllers', ['ngResource']);
