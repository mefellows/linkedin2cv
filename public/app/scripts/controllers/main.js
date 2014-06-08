'use strict';

angular.module('linkedin-to-resumeApp')
    .controller('MainCtrl', ['$scope', '$http', 'LinkedinToResume', function ($scope, $http, LinkedinToResume) {

        // Default website
        $scope.message = 'Sockets will replace me - enter stuff above to find out!'

        /**
         * Generate a LinkedinToResume
         */
        $scope.generateLinkedinToResume = function (ping) {

            var data = LinkedinToResume.getResponse({'message': ping})
            data.then(function (result) {
                console.log(result)

                $scope.message = 'API said: ' + result.message;
            });
        }
    }]);