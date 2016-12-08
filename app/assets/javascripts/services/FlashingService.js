angular.module('ippon').service('FlashingService', ['Flash', function(Flash) {
  this.flashRestFailed = function(what, resourceName, httpResponse) {
    Flash.create('danger',  what + " " + resourceName + " {{'ERROR_FAILED' | translate}}" + ':'
    + httpResponse.status + ': ' + httpResponse.statusText);
  };
}]);
