# Controller Definitions
module = angular.module('app.controllers', [])








# App Controller
# -----------------------------------------
AppController = module.controller('AppController',
  ['$scope', '$location', '$rootScope', '$log', '$route', 'ListingFilter', 'User', 'Dialog', ($scope, $location, $rootScope, $log, $route, ListingFilter, User, Dialog) ->

    oldRoute = null

    $scope.openDialog = ->
      Dialog.show('partials/business_profile.jade')

#    $scope.$on '$locationChangeSuccess', (event, newLocation, oldLocation) ->
#      console.debug(event)
#      if oldRoute != null
#        $route.current = oldRoute
#        oldRoute = null
#
#      $log.debug Dialog.prevRoute()

    $scope.listingFilter = ListingFilter

#    $fb.init().then (fbuser) ->
#
#      User.get({id: fbuser.id}
#        (user) ->
#          console.log(user)
#        () ->
#          console.log('error getting user')
#      )


      #User.find(user.id)


#    $scope.fblogin = () ->
#      $fb.login().then (user) ->
#        $scope.isAuthorized = true
#        $scope.user.loggedIn = true
#        $scope.user.name = user.name
#        $scope.user.avatar = user.picture.data
#        User.$save()


  ]
)





# Home Controller
# -----------------------------------------
HomeController = module.controller('HomeController',
  ['$scope', ($scope) ->
    return
  ]
)





# Toolbar Controller
# -----------------------------------------
ToolbarController = module.controller('ToolbarController',
  ['$scope', '$route', 'ListingFilter', 'User', ($scope, $route, ListingFilter, User) ->

    $scope.user = User
    $scope.userToggles = User.prefs.ui.toggles

#    if $route.current.params.keywords
#      ListingFilter.resultsLabel = "Showing results for: '#{$route.current.params.keywords}'"
#    else
#      ListingFilter.resultsLabel = $route.current.params.category

    $scope.setLayout = (layout) ->
      $scope.userToggles.listing_layout = layout
      localStorage.setItem('layout_option', layout)

  ]
)





# Search Controller
# -----------------------------------------
SearchController = module.controller('SearchController',
  ['$scope', '$location', '$rootScope', 'ListingFilter', ($scope, $location, $rootScope, ListingFilter) ->

    $scope.listingFilter = ListingFilter

  ]
)



# Sidebar Controller
# -----------------------------------------
SidebarController = module.controller('SidebarController',
  ['$scope', ($scope) ->
    return
  ]
)





# Listing Controller
# -----------------------------------------
ListingController = module.controller('ListingController',
  ['$scope',
   '$location',
   '$route',
   '$q',
   'Coupons'
   'ListingFilter',
   'ScrollWatch',
   'User',
   'Dialog',
    ($scope, $location, $route, $q, Coupons, ListingFilter, ScrollWatch, User, Dialog) ->

      $scope.listingFilter = ListingFilter
      $scope.userToggles = User.prefs.ui.toggles
      $scope.listings = []
      $scope.scrollBottomReached = false

      # turn on loader gif
      $scope.listingFilter.loading = true


      lRoute = $route.current
      $scope.$on '$routeChangeStart', (event, newRoute, oldRoute) ->
        $route.current = lRoute


      # get all listings (based on URL)
      Coupons.getAllListingsByKeyword($route.current.params.keywords).then(

        # promise successfully resolved
        (listings) ->

          $scope.gotError = false

          # concatenate listing arrays into single array
          $scope.allListings = Array.prototype.concat(
            listings.keywordCouponsList,
            listings.keywordGroceryList,
            listings.keywordSdcCouponsList,
            listings.keywordDealsList
          )

          # consume subset of listings
          $scope.appendListings()

          # turn off the loading indicator
          $scope.listingFilter.loading = false

        # promise rejected
        (error) ->
          console.debug(error)
          displayError(error)
      )

      # listen for scroll to reach bottom
      $scope.$on 'scrollLimit', (ev, data) ->
        $scope.scrollBottomReached = true


      # TODO: figure out how to get logos from differing listing types
      # get correct logo image source
      $scope.getLogoSrc = () ->
        if this.listing.slugTypeId != null
          if this.listing.logoImageFileName
            return 'http://www.valpak.com/img/print/' + this.listing.logoImageFileName
          else
            return '/img/defaultLogo.png'
        else
          if this.listing.logoImageFileName
            return this.listing.logoImageFileName
          else if this.listing.dealImageURL
            return this.listing.dealImageURL
          else
            return '/img/defaultLogo.png'

      $scope.appendListings = () ->
        $scope.listings = $scope.listings.concat($scope.allListings.splice(0, 20))  # get next 20 listings
        $scope.scrollBottomReached = false  # reset scroll watcher


      displayError = (error) ->
        $scope.listingFilter.loading = false
        $scope.gotError = true

        if error.status is 403
          $scope.errorInfo = "You ain't logged in, bro."
        else
          $scope.errorInfo = "Sorry, dawg. No can do."

  ]
)


# Business Profile Controller
# -----------------------------------------
BusinessProfileController = module.controller('BusinessProfileController',
  ['$scope', '$location', '$route', 'BusinessProfileLoader', ($scope, $location, $route, BusinessProfileLoader) ->

    BusinessProfileLoader($route.current.params.profileId).then (profile) ->
      $scope.profile = profile
      $scope.businessGeo = profile.selectedAddressOffer.geoCoordinates


  ]
)










