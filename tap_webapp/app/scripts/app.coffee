'use strict'

###*
 # @ngdoc overview
 # @name tapWebappApp
 # @description
 # # tapWebappApp
 #
 # Main module of the application.
###
angular
  .module('tapWebappApp', [
    'ngAnimate'
    'ngCookies'
    'ngResource'
    'ngRoute'
    'ngSanitize'
    'ngTouch'
    'firebase'
  ])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'

