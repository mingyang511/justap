'use strict'

###*
 # @ngdoc function
 # @name tapWebappApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the tapWebappApp
###
angular.module('tapWebappApp')
  .controller 'MainCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
