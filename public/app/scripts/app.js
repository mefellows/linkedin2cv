'use strict';

angular
  .module('linkedin-to-resumeApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngRoute',
    'linkedin-to-resumeServices'
  ])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });
