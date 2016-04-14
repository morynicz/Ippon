angular.module('ippon',['templates', 'ngRoute', 'controllers']);

angular.module('ippon').config(['$routeProvider',
function($routeProvider) {
  $routeProvider.when('/', {
    templateUrl: '_index.html',
    controller: 'HomePageController'
  });
}]);

angular.module('controllers', []);
