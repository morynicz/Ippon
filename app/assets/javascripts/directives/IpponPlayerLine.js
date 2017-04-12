angular.module('ippon').directive('ipponPlayerLine', function() {
    return {
        scope : {
            player : "=player"
        },
        templateUrl: 'Players/_line.html'
    }
});