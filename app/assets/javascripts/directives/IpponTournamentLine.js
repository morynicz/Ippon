angular.module('ippon').directive('ipponTournamentLine', function() {
    return {
        scope : {
            tournament : "=tournament"
        },
        templateUrl: 'Tournaments/_line.html'
    }
});