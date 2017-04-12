angular.module('ippon').directive('ipponGroupBrief', function() {
    return {
        scope : {
            element : "=element"
        },
        templateUrl: 'Groups/_brief.html'
    }
});