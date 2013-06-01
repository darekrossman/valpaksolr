# Controller Definitions
module = angular.module('app.controllers', [])


# Home Controller
# -----------------------------------------
module.controller('AppController',
  ['$scope', 'ListingFilter', ($scope, ListingFilter) ->
    $scope.listingFilter = ListingFilter
  ]
)





# Home Controller
# -----------------------------------------
module.controller('HomeController',
  ['$scope', ($scope) ->

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
      ListingFilter.resultsLabel = $route.current.params.cat

    $scope.setLayout = (layout) ->
      ListingFilter.layoutOption = layout
      $scope.layout = layout
      localStorage.setItem('layout_option', layout)

  ]
)





# Search Controller
# -----------------------------------------
module.controller('SearchController',
  ['$scope', '$location', 'ListingFilter', ($scope, $location, ListingFilter) ->

    $scope.listingFilter = ListingFilter
    $scope.queryKeyword = () ->
      console.log('QUERYING')
      $location.url("/search/?keywords=#{ListingFilter.searchText}")
  ]
)



# Sidebar Controller
# -----------------------------------------
module.controller('SidebarController',
  ['$scope', ($scope) ->

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
   'KeywordListingLoader',
   'CategoryListingsLoader',
   'ListingFilter',
    ($scope, $location, $route, $q, $rootScope, KeywordListingLoader, CategoryListingsLoader, ListingFilter) ->

      requestedPage = $route.current.params.page

      $scope.listingFilter = ListingFilter
      $scope.listings = []

      ListingFilter.loading = true


      if $route.current.params.keywords
        if localStorage.getItem('search_pizza') and $route.current.params.keywords
          delay = $q.defer()
          getListings = delay.promise
          delay.resolve( JSON.parse(localStorage.getItem('search_pizza')) )
        else
          getListings = KeywordListingLoader()
          ListingFilter.resultsLabel = "Showing results for: '#{$route.current.params.keywords}'"

      else if $route.current.params.cat
        getListings = CategoryListingsLoader()
        ListingFilter.resultsLabel = $route.current.params.cat

      getListings.then (listings) ->

        if $route.current.params.keywords == 'pizza'
          unless localStorage.getItem('search_pizza')
            JSON.stringify(localStorage.setItem('search_pizza', JSON.stringify(listings)))

        $scope.allListings = Array.prototype.concat(
          listings.keywordCouponsList,
          listings.keywordGroceryList,
          listings.keywordSdcCouponsList,
          listings.keywordDealsList
        )



        $scope.appendListings()

        # turn off the loading indicator
        ListingFilter.loading = false


      $scope.$on 'e:scroll', () ->
        console.log 'scrolling!'

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
        $scope.listings = $scope.listings.concat($scope.allListings.splice(0, 20))
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










