module = angular.module('app.directives', [])


module.directive 'ngTap', ->
  (scope, element, attrs) ->
    tapping = false
    element.bind 'touchstart', (e) -> tapping = true
    element.bind 'touchmove', (e) -> tapping = false
    element.bind 'touchend', (e) -> scope.$apply(attrs['ngTap'], element) if tapping









# ------------------------------------------------------------------------
# Directive: scroll-view
# Dependencies: ScrollWatch
# Inherits: --
#
# This directive can be attached to elements that need to monitor scroll
# events. It keeps track of the current scroll position of the element and
# reports to the shared ScrollWatch service to trigger the desired event.

module.directive 'scrollView', ['ScrollWatch', (ScrollWatch) ->
  controller: ($scope) ->
    $scope.offsetTop = 0
  link: (scope, element, attrs, $rootScope) ->
    element
      .addClass('scroll-view')
      .bind 'scroll', (e) ->
        scope.$apply(
          scope.offsetTop = element.scrollTop()
        )
        if (element.height() + scope.offsetTop + 100) >= element[0].scrollHeight
          ScrollWatch.scrollLimit(element)
]







# ------------------------------------------------------------------------
# Directive: fixed-child
# Dependencies: ScrollWatch
# Inherits: --
#
# This directive will set an element to a fixed position while maintaining
# the correct width within its parent.

module.directive 'fixedChild', ['$document', 'ScrollWatch', ($document, ScrollWatch) ->
  link: (scope, element, attrs) ->
    parent = element.parent()
    parentWidth = parent.width()

    startingOffset = element.offset().top
    fixedAtOffset = 48 # height of header
    isFixed = false

    nextEl = element.next()
    nextElOffset = nextEl.position().top - fixedAtOffset



    $document.bind 'scroll', (event) ->
      docScrollTop = $document.scrollTop()
      if docScrollTop >= startingOffset - (fixedAtOffset) and !isFixed
        element.css
          'position': 'fixed'
          'margin-top': 0
          'top': fixedAtOffset + 'px'
        nextEl.css
          'margin-top': nextElOffset + 'px'
        isFixed = true

      if docScrollTop < startingOffset - (fixedAtOffset) and isFixed
        element.css
          'margin-top': startingOffset - fixedAtOffset + 'px'
          'position': 'relative'
          'top': 0
        nextEl.css
          'margin-top': 0
        isFixed = false
]





# ------------------------------------------------------------------------
# Directive: coupontile
# Dependencies: --
# Inherits: scroll-view
#
# A directive to handle individual coupon elements. It inherits it's scope
# from the scroll-view directive as scope.$parent. This would typically
# be applied to a listing of coupon results within a scroll-view. Each
# coupon is made aware of it visibility within the scroll view (above,
# visible, below).

module.directive 'coupontile', () ->
  replace: true
  require: '^scrollView'
  templateUrl: '/partials/coupontile.jade'
  link: (scope, element, attrs) ->
    isDragging = false
    touchStartX = 0

    element
      .addClass('tile')
      .addClass("tile-#{attrs.type}")

    if scope.listing.selectedDetail?
      scope.listing.title = scope.listing.selectedDetail.offerText

    scope.initialOffset = element.offset().top

    # TODO - needs performance optimization (temporarily disabled)
    if (false)
      # browser is not touch enabled
      if (!('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch)
        scope.$watch '$parent.offsetTop', () ->
          tileTop = element.offset().top
          scrollTop = scope.$parent.offsetTop
          winH = angular.element(window).height()

          if tileTop < winH && tileTop > 0
            element.addClass('scroll-visible')
            element.removeClass('scroll-above')
            element.removeClass('scroll-below')
          else
            element.removeClass('scroll-visible')
            if tileTop < 100
              element.addClass('scroll-above')
            else
              element.addClass('scroll-below')

      # browser is touch enabled
      else
        element.addClass('scroll-visible')

        element.parent().hammer().on 'dragright', (ev) ->
          ev.gesture.preventDefault()
          # console.log ev.gesture

          if ev.gesture.distance < 100
            element
              .removeClass('transition1')
              .css
                'transform': 'translateZ(0) translateX(' + Math.round(ev.gesture.distance) + 'px)'

        element.parent().hammer().on 'dragend', (ev) ->
          element
            .addClass('transition1')
            .css
              'transform': 'translateX(0px) translateZ(0)'
    else
      element.addClass('scroll-visible')








# Google Map
module.directive 'gmap', () ->
  link: (scope, element, attrs) ->
    element
      .addClass('gmap')
      .googlemap
        width: '100%'
        height: '200px'
        zoom: 16
        locations: [{
                    lat: scope.businessGeo.latitude
                    lon: scope.businessGeo.longitude
                    primary: true
                    }]


module.directive 'couponSearch',
  ['ListingFilter', '$location', '$rootScope', 'User', (ListingFilter, $location, $rootScope, User) ->

    scope: true
    templateUrl: '/partials/searchbar.jade'
    link: (scope, element, attrs) ->
      searchField = angular.element(element.find('.search-input'))
      submitBtn = angular.element(element.find('.submit'))

      scope.performSearch = () ->
        searchField.val('').blur()
        $location.url("/coupons/query?keywords=#{ListingFilter.searchTerms}&geo=#{User.geo}")

      scope.listingFilter = ListingFilter

  ]



module.directive 'paginate', [() ->
  require: '^scrollView'
  link: (scope, element, attrs) ->
    scope.$watch 'offsetTop', (_new, _prev) ->
      # do stuff on scroll


]



module.directive 'loader', ['$rootScope', '$timeout', 'ListingFilter', ($rootScope, $timeout, ListingFilter) ->
  template: '<div><img src="/img/progress.gif"/><p ng-transclude></p></div>'
  transclude: true
  link: (scope, element, attrs) ->

    transitionSpeed = 0

    scope.listingFilter = ListingFilter

    element.css
      'transition-duration': transitionSpeed + 's'

    element.addClass('loader')

  # $rootScope.$on '$routeChangeStart', () ->
  #   element.removeClass('hide')

  # $rootScope.$on '$routeChangeSuccess', () ->
  #   $timeout(() ->
  #       element.addClass('fadeOut')
  #     , 1)

  #   $timeout(() ->
  #       if element.hasClass('fadeOut')
  #         element.addClass('hide')
  #         element.removeClass('fadeOut')
  #     , (transitionSpeed * 1000) + 10)

]


module.directive 'loadmore', () ->
  scope:
    action: '&'
    show: '='
  link: (scope, element, attributes) ->


    scope.$watch 'show', (visible) ->
      element.css('visibility', 'visible') if visible
      element.css('visibility', 'hidden') if not visible



    element.hammer().on 'tap', () ->
#      sv = element.parents('.scroll-view')
#      st = sv.scrollTop()
#      element.parents('.scroll-view').animate({
#        'scrollTop': st + 200 + 'px'
#      }, 600)
      element.parent().prev().css({
        'border-bottom': '16px solid #EEE'
      })
      scope.$apply(
        scope.action.call()
      )


module.directive 'slowScroll', ['$document', ($document) ->
  link: (scope, element, attrs) ->
    $document.bind 'scroll', () ->
      element.css
        top: -0.2 * $document.scrollTop() + 48 + 'px'


]






module.directive 'dropdownMenu', [() ->
  link: (scope, element, attrs) ->
    element.addClass('dd-menu')
    element.children().first().append('<span class="icon-down-open"></span>')
]
