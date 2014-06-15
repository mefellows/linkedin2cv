'use strict';

angular
  .module('linkedin2cvApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngRoute',
    'linkedin2cvServices'
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
