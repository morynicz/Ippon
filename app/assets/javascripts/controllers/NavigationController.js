angular.module('ippon').controller('NavigationController',[
  '$scope',
  'Auth',
  '$translate',
function($scope, Auth, $translate) {
  $scope.signedIn = Auth.isAuthenticated;
  $scope.logout = Auth.logout;

  Auth.currentUser().then(function (user) {
    $scope.user = user;
  });

  $scope.$on('devise:login', function(e, user) {
    $scope.user = user;
  });

  $scope.$on('devise:logout', function(e,user) {
    $scope.user = {};
  });

  $scope.changeLanguage = function(langKey) {
    $translate.use(langKey);
  };
}]);
