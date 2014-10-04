'use strict'

describe 'Directive: tapButton', ->

  # load the directive's module
  beforeEach module 'tapWebappApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<tap-button></tap-button>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the tapButton directive'
