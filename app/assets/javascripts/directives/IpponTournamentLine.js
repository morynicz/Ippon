angular.module('ippon').directive('ipponTournamentLine', function() {
    return {
        scope : {
            tournament : "=tournament",
            viewTournament: "=viewTournamentFcn"
        },
        templateUrl: 'Tournaments/_line.html'
    }
});