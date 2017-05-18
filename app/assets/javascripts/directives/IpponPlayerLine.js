angular.module('ippon').directive('ipponPlayerLine', function() {
    return {
        scope : {
            player : "=player",
            viewPlayer : "=viewPlayerFcn"
        },
        templateUrl: 'Players/_line.html'
    }
});