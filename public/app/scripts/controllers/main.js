'use strict';

angular.module('linkedin2cv App')
    .controller('MainCtrl', ['$scope', '$http', 'Linkedin2CV', function ($scope, $http, Linkedin2CV) {

        // Default website
        $scope.message = 'Sockets will replace me - enter stuff above to find out!'

        /**
         * Generate a Linkedin2CV
         */
        $scope.generateLinkedin2CV = function (ping) {

            var data = Linkedin2CV.getResponse({'message': ping})
            data.then(function (result) {
                console.log(result)

                $scope.message = 'API said: ' + result.message;
            });
        }
    }]);