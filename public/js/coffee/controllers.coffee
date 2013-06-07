# Controller Definitions
module = angular.module('app.controllers', [])








# App Controller
# -----------------------------------------
AppController = module.controller('AppController',
  ['$scope', '$fb', '$rootScope', '$log', 'ListingFilter', 'User', ($scope, $fb, $rootScope, $log, ListingFilter, User) ->

    $scope.listingFilter = ListingFilter

    $scope.user = User

    $rootScope.$on '$routeChangeError', (ev, current, previous, rejection) ->
      console.debug('uh oh! something went wrong!')

    $fb.init().then (user) ->
      $scope.user.isAuthenticated = true
      $scope.user.loggedIn = true
      $scope.user.name = user.name
      $scope.user.avatar = user.picture.data

      $scope.user.fbId = user.id
      $scope.name = user.name

      $scope.user.$save()

      #User.find(user.id)


    $scope.fblogin = () ->
      $fb.login().then (user) ->
        $scope.isAuthorized = true
        $scope.user.loggedIn = true
        $scope.user.name = user.name
        $scope.user.avatar = user.picture.data
        User.$save()

    $rootScope.userDetail =
      geo: '33703'

  ]
)





# Home Controller
# -----------------------------------------
module.controller('HomeController',
  ['$scope', ($scope) ->
    return
  ]
)





# Toolbar Controller
# -----------------------------------------
module.controller('ToolbarController',
  ['$scope', '$route', 'ListingFilter', ($scope, $route, ListingFilter) ->

    $scope.layout = ListingFilter.layoutOption

    if $route.current.params.keywords
      ListingFilter.resultsLabel = "Showing results for: '#{$route.current.params.keywords}'"
    else
      ListingFilter.resultsLabel = $route.current.params.category

    $scope.setLayout = (layout) ->
      ListingFilter.layoutOption = layout
      $scope.layout = layout
      localStorage.setItem('layout_option', layout)

  ]
)





# Search Controller
# -----------------------------------------
module.controller('SearchController',
  ['$scope', '$location', '$rootScope', 'ListingFilter', ($scope, $location, $rootScope, ListingFilter) ->

    $scope.listingFilter = ListingFilter

  ]
)



# Sidebar Controller
# -----------------------------------------
module.controller('SidebarController',
  ['$scope', ($scope) ->
    return
  ]
)





# Listing Controller
# -----------------------------------------
module.controller('ListingController',
  ['$scope',
   '$location',
   '$route',
   '$rootScope',
   '$q',
   'Coupons'
   'ListingFilter',
   'ScrollWatch'
    ($scope, $location, $route, $q, $rootScope, Coupons, ListingFilter, ScrollWatch) ->

      $scope.listingFilter = ListingFilter
      $scope.listings = []
      $scope.scrollBottomReached = false

      # turn on loader gif
      $scope.listingFilter.loading = true

      # get all listings (based on URL)
      Coupons.getAllListings().then(

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
        $scope.errorInfo = "404, dawg."
  ]
)


# Business Profile Controller
# -----------------------------------------
module.controller('BusinessProfileController',
  ['$scope', '$location', '$route', 'profile', ($scope, $location, $route, profile) ->

    $scope.profile = profile
    $scope.businessGeo = profile.selectedAddressOffer.geoCoordinates

#    console.log(profile)

  ]
)










