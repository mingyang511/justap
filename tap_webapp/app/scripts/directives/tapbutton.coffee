'use strict'

###*
 # @ngdoc directive
 # @name tapWebappApp.directive:tapButton
 # @description
 # # tapButton
###
angular.module('tapWebappApp')
  .directive 'tapButton', ->
    templateUrl: '/views/tapButton.html'
    restrict: 'E'
    scope: {}
    link: (scope, element, attrs) ->
      upButton = $(".tap-button-up")
      console.log upButton

      scope.button =
        up: true
        shrinkToCursor: ->
          console.log 

      