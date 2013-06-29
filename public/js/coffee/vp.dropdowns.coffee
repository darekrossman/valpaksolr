module = angular.module('vp.dropdowns', [])



# Service: DropdownMgr

module.factory 'DropdownMgr', [() ->
  openDropdowns = []

  obj = {
    addActiveDropdown: (scope) ->
      openDropdowns.push(scope)

    removeActiveDropdown: (scope) ->
      openDropdowns.splice( _.indexOf(openDropdowns, scope), 1 )

    closeAllDropdowns: () ->
      if openDropdowns.length > 0
        angular.forEach openDropdowns, (scope, index) ->
          scope.closeDropdown()

      openDropdowns = []
  }

  return obj

]


# ------------------------------------------------------------------------
# Directive: Dropdowns
# Dependencies: --
# Inherits: --
#
# A directive to handle dropdown lists

module.directive 'dropdownMenu', ['$document', '$timeout', 'DropdownMgr', ($document, $timeout, DropdownMgr) ->
  scope:
    toggle: '@'

  controller: ($scope) ->
    $scope.isActive = false
    $scope.elementHeight = 0
    $scope.uid = 'dd-' + Date.now()

    #DropdownMgr.registerComponent('dropdowns', $scope)

  link: (scope, element, attrs) ->

    delay = null

    scope.elementHeight = element.height()
    scope.toggleEvent = if angular.isUndefined(scope.toggle) then 'click' else scope.toggle


    scope.closeDropdown = ->
      $timeout.cancel(delay)
      phase = scope.$root.$$phase
      fn = ->
        scope.isActive = false
        $document.unbind 'click.' + scope.uid
        element.removeClass('dropdown-active')
        DropdownMgr.removeActiveDropdown(scope)

      if phase == '$apply' or phase == '$digest'
        fn()
      else
        scope.$apply(fn)



    # Toggle the state of the dropdown
    # Once the dropdown is activated, clicking anywhere in the document will
    # close the dropdown automatically (unless toggleEvent is 'hover').
    toggleActiveState = scope.toggleState = (event) ->
      scope.$apply () ->
        scope.isActive = !scope.isActive

        if scope.isActive
          element.addClass('dropdown-active')
          DropdownMgr.closeAllDropdowns()
          DropdownMgr.addActiveDropdown(scope)
          if scope.toggleEvent != 'hover'
            $document.bind 'click.' + scope.uid, (ev) ->
              scope.closeDropdown()
        else
          scope.closeDropdown()

        event.stopPropagation() # prevent the initial click from triggering a close
        event.preventDefault()


    # add class to containing element
    element.addClass('vp-dropdown')

    # append dropdown arrow icon
    element.children().first().append('<span class="icon-down-open"></span>')



    # toggle active state on user interaction
    if scope.toggleEvent == 'hover'

      element.bind 'mouseenter', (event) ->
        $timeout.cancel(delay)
        unless scope.isActive
          delay = $timeout(
            () =>
              ev = event
              toggleActiveState(ev)
            200, false
          )

      element.bind 'mouseleave', (event) ->
        $timeout.cancel(delay)
        if scope.isActive
          delay = $timeout(
            () =>
              ev = event
              toggleActiveState(ev)
            400, false
          )

    else
      element.bind scope.toggleEvent, toggleActiveState

]




module.directive 'dropdownOptions', () ->
  require: '^dropdownMenu'
  link: (scope, element, attrs) ->

    element.on 'click', 'li', (event) ->
      event.stopPropagation()
      scope.closeDropdown()


