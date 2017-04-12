angular.module('ippon').directive('ipponPlayoffTree', function() {
    return {
        scope : {
            levels : "=levels"
        },
        templateUrl: 'Playoffs/_tree.html'
    }
});