'use strict';

/**
 * @ngdoc function
 * @name tapWebappApp.controller:AboutCtrl
 * @description
 * # AboutCtrl
 * Controller of the tapWebappApp
 */
angular.module('tapWebappApp')
  .controller('AboutCtrl', function ($scope) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
  });
