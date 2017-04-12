angular.module('ippon').directive('ipponTeamBrief', function() {
    return {
        scope : {
            element : "=element"
        },
        templateUrl: 'Teams/_brief.html'
    }
});