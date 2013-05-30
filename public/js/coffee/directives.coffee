module = angular.module('app.directives', [])


module.directive 'ngTap', ->
  (scope, element, attrs) ->
    tapping = false
    element.bind 'touchstart', (e) -> tapping = true
    element.bind 'touchmove', (e) -> tapping = false
    element.bind 'touchend', (e) -> scope.$apply(attrs['ngTap'], element) if tapping

module.directive 'scrollView', () ->
  controller: ($scope) ->
    $scope.offsetTop = 0
  link: (scope, element, attrs) ->
    console.log scope
    element
      .addClass('scroll-view')
      .bind 'scroll', (e) ->
        scope.$apply(
          scope.offsetTop = element.scrollTop()
        )

cnt = 161
# Coupontile
#   - basic: display a coupon tile with basic info and functionality
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
    # .css('z-index', cnt--)

    if scope.listing.selectedDetail?
      scope.listing.title = scope.listing.selectedDetail.offerText

    scope.initialOffset = element.offset().top

    if !angular.element('html').hasClass('touch')
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


module.directive 'couponSearch', ['ListingFilter', '$location', (ListingFilter, $location) ->
  scope: true
  templateUrl: '/partials/searchbar.jade'
  link: (scope, element, attrs) ->
    searchField = angular.element(element.find('.search-input'))
    submitBtn = angular.element(element.find('.submit'))

    scope.performSearch = () ->
      $location.url("/search/?keywords=#{ListingFilter.searchTerms}")
      searchField.val('').blur()

    scope.listingFilter = ListingFilter
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


