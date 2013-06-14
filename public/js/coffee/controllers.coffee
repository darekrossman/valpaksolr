# Controller Definitions
module = angular.module('app.controllers', [])








# App Controller
# -----------------------------------------
AppController = module.controller('AppController',
  ['$scope', '$rootScope', '$log', 'ListingFilter', 'User', ($scope, $rootScope, $log, ListingFilter, User) ->

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


    if $route.current.params.keywords
      ListingFilter.resultsLabel = "Showing results for: '#{$route.current.params.keywords}'"
    else
      ListingFilter.resultsLabel = $route.current.params.category

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
   '$rootScope',
   '$q',
   'Coupons'
   'ListingFilter',
   'ScrollWatch',
   'User',
    ($scope, $location, $route, $q, $rootScope, Coupons, ListingFilter, ScrollWatch, User) ->

      $scope.listingFilter = ListingFilter
      $scope.userToggles = User.prefs.ui.toggles
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

        if error.status is 403
          $scope.errorInfo = "You ain't logged in, bro."
        else
          $scope.errorInfo = "Sorry, dawg. No can do."

  ]
)


# Business Profile Controller
# -----------------------------------------
BusinessProfileController = module.controller('BusinessProfileController',
  ['$scope', '$location', '$route', 'profile', ($scope, $location, $route, profile) ->

    $scope.profile = profile
    $scope.businessGeo = profile.selectedAddressOffer.geoCoordinates

#    console.log(profile)

  ]
)










