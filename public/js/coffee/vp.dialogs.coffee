module = angular.module('vp.dialogs', [])

# ------------------------------------------------------------------------
# Service: Dialog
# Dependencies: --
# Inherits: --
#
# A service for handling dialogs, modals and overlays.

module.factory('Dialog',
  ['$document', '$compile', '$rootScope', '$controller', '$location', '$timeout', '$route',
  ($document, $compile, $rootScope, $controller, $location, $timeout, $route)->

    defaults = {
      id: null
      title: 'Default Title'
      backdrop: true
      controller: 'BusinessProfileController'
      backdropClass: "modal-backdrop"
      footerTemplate: null
      dialogClass: "dialog"
      activeClass: "dialog-active"
      dialogBackgroundClass: "dialog-background"
      backgroundActiveClass: "dialog-background-active"
      animationOutSpeed: 300
    }

    dialogEl = null
    dialogBg = null
    scope = null
    options = {}
    prevLocation = null
    prevRoute = null
    isClosing = false
    ctrl = null


    body = $document.find('body')

    show = (template, _options, locals) ->
      options = angular.extend({}, defaults, _options)

      dialogEl = angular.element('<div class="' + options.dialogClass + '" ng-include="\'' + template + '\'"></div>')
      dialogBg = angular.element('<div class="' + options.dialogBackgroundClass + '"></div>')

      dialogBg.bind 'click', () ->
        scope.$apply(
          ()->
            destroy()
        )

      scope = options.scope || $rootScope.$new()
      locals = angular.extend({$scope: scope, locals})



      # store previous route and location
      prevLocation = $location.url()
      prevRoute = $route.current

      # intercept route change when url changes
      scope.$on '$locationChangeSuccess', (event, newLoc, oldLoc) ->
        if isClosing
          $route.current = prevRoute
          $timeout(
            () ->
              scope.$destroy()
              isClosing = false
              ctrl = null
          )
        else
          ctrl = $controller(options.controller, locals)
          $route.current = prevRoute




      dialogEl.contents().data('$ngControllerController', ctrl)

      $compile(dialogEl)(scope)
      body.append(dialogBg)
      body.append(dialogEl)



      $timeout(
        () ->
          dialogEl.addClass(options.activeClass)
          dialogBg.addClass(options.backgroundActiveClass)
        , 5
      )

    destroy = ->
      dialogEl.removeClass(options.activeClass)
      dialogBg.removeClass(options.backgroundActiveClass)

      $timeout(
        () ->
          dialogEl.remove()
          dialogBg.remove()
          isClosing = true
          $location.url(prevLocation)
        , options.animationOutSpeed
      )

    getPrevRoute = ->
      return prevRoute


    return {
      show: show
      destroy: destroy
      prevRoute: getPrevRoute
    }

  ]
)