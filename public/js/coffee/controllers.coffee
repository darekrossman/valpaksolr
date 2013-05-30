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
   '$q',
   'KeywordListingLoader',
   'CategoryListingsLoader',
   'ListingFilter',
    ($scope, $location, $route, $q, KeywordListingLoader, CategoryListingsLoader, ListingFilter) ->

      $scope.listingFilter = ListingFilter

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
            console.log localStorage.getItem('search_pizza')

        $scope.listings = [
          listings.keywordCouponsList
          listings.keywordGroceryList
          listings.keywordSdcCouponsList
          listings.keywordDealsList
        ]

        $scope.couponListings = listings.keywordCouponsList.splice(0,1)
        $scope.selectedDetail = $scope.listings.selectedDetail

        $scope.dealsListings = listings.keywordDealsList.splice(0,1)
        $scope.groceryListings = listings.keywordGroceryList.splice(0, 1)
        $scope.sdcListings = listings.keywordSdcCouponsList.splice(0,20)

        ListingFilter.loading = false

      $scope.getLogoSrc = (logo) ->
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
  ]
)


# Business Profile Controller
# -----------------------------------------
module.controller('BusinessProfileController',
  ['$scope', '$location', '$route', 'profile', ($scope, $location, $route, profile) ->

    $scope.profile = profile
    $scope.businessGeo = profile.selectedAddressOffer.geoCoordinates

    console.log(profile)

  ]
)










