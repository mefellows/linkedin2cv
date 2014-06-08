'use strict';

angular
  .module('linkedin2resumeApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngRoute',
    'linkedin2resumeServices'
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
