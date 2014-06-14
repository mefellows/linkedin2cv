'use strict';

angular
  .module('linkedin2cv App', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngRoute',
    'linkedin2cv Services'
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
