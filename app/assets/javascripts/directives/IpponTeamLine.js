angular.module('ippon').directive('ipponTeamLine', function() {
    return {
        scope : {
            team : "=team"
        },
        templateUrl: 'Teams/_line.html'
    }
});