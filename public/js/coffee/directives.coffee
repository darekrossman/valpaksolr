angular.module('app.directives', [])

  # Coupontile
  #   - basic: display a coupon tile with basic info and functionality
  .directive 'coupontile', () ->
    replace: true
    templateUrl: '/partials/coupontile.jade'
    link: (scope, element, attrs) ->
      element
        .addClass('tile')
        .addClass(attrs.type)


  # Coupontile
  #   - grocery: display a coupon tile with basic info and functionality
  .directive 'coupontileGrocery', () ->
    replace: true
    templateUrl: '/partials/coupontile_grocery.jade'
    link: (scope, element, attrs) ->
      element
        .addClass('tile')
        .addClass(attrs.type)

  # Coupontile
  #   - deal: display a coupon tile with basic info and functionality
  .directive 'coupontileDeal', () ->
    replace: true
    templateUrl: '/partials/coupontile_deal.jade'
    link: (scope, element, attrs) ->
      element
        .addClass('tile')
        .addClass(attrs.type)

  # Coupontile
  #   - sdc: display a coupon tile with basic info and functionality
  .directive 'coupontileSdc', () ->
    replace: true
    templateUrl: '/partials/coupontile_sdc.jade'
    link: (scope, element, attrs) ->
      element
        .addClass('tile')
        .addClass(attrs.type)

  # Coupontile
  #   - sdc: display a coupon tile with basic info and functionality
  .directive 'coupontileDetail', () ->
    replace: true
    templateUrl: '/partials/coupontile_detail.jade'
    link: (scope, element, attrs) ->
      element
        .addClass('tile')
        .addClass(attrs.type)

  # Google Map
  .directive 'gmap', () ->
    link: (scope, element, attrs) ->
      console.log(scope.businessGeo)
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

  .directive 'slidemenuToggle', (ListingFilter) ->
    template: 'MENU'
    link: (scope, element, attrs) ->
      element.bind 'click', () ->
        ListingFilter.slidemenuActive = !ListingFilter.slidemenuActive
        console.log(ListingFilter)





