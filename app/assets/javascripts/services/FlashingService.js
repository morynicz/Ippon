angular.module('ippon').service('FlashingService', ['Flash', function(Flash) {
  this.flashRestFailed = function(functionName, httpResponse) {
    Flash.create('danger', functionName + ' failed: '
    + httpResponse.status + ': ' + httpResponse.statusText);
  }
}]);
