angular.module('ippon').directive('ipponTeamLine', function() {
    return {
        scope : {
            team : "=team",
            showTeam : "=showTeam"
        },
        templateUrl: 'Teams/_line.html'
    }
});