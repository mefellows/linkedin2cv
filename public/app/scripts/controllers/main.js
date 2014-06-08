'use strict';

angular.module('linkedin2resumeApp')
    .controller('MainCtrl', ['$scope', '$http', 'Linkedin2Resume', function ($scope, $http, Linkedin2Resume) {

        // Default website
        $scope.message = 'Sockets will replace me - enter stuff above to find out!'

        /**
         * Generate a Linkedin2Resume
         */
        $scope.generateLinkedin2Resume = function (ping) {

            var data = Linkedin2Resume.getResponse({'message': ping})
            data.then(function (result) {
                console.log(result)

                $scope.message = 'API said: ' + result.message;
            });
        }
    }]);