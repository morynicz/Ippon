angular.module('ippon').directive('ipponTeamBrief', function() {
    return {
        scope : {
            element : "=element",
            viewTeam : "=viewTeamFcn",
            viewPlayer : "=viewPlayerFcn"
        },
        templateUrl: 'Teams/_brief.html'
    }
});