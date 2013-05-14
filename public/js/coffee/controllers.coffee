# Controller Definitions
module = angular.module('app.controllers', [])


# Home Controller
# -----------------------------------------
module.controller('HomeController',
  ['$scope', ($scope) ->

  ]
)





# Search Controller
# -----------------------------------------
module.controller('SearchController',
  ['$scope', '$location', 'ListingFilter', ($scope, $location, ListingFilter) ->

    $scope.listingFilter = ListingFilter
    $scope.queryKeyword = () ->
      $location.url("/search/?keywords=#{ListingFilter.searchText}")
      angular.element('.search-input').blur()
  ]
)





# Listing Controller
# -----------------------------------------
module.controller('ListingController',
  ['$scope',
  '$location',
  '$route',
  'KeywordListingLoader',
  'CategoryListingsLoader',
  'ListingFilter',
  ($scope, $location, $route, KeywordListingLoader, CategoryListingsLoader, ListingFilter) ->

    ListingFilter.loading = true

    $scope.listingFilter = ListingFilter
    $scope.selectedCategory = ''
    $scope.currentSearch = $route.current.params.keywords


    if $route.current.params.keywords
      getListings = KeywordListingLoader()
      ListingFilter.resultsLabel = "Showing results for: '#{$route.current.params.keywords}'"
    else if $route.current.params.cat
      getListings = CategoryListingsLoader()
      ListingFilter.resultsLabel = $route.current.params.cat

    getListings.then (listings)->
      console.log(listings)

      $scope.listings = [
        listings.keywordCouponsList
        listings.keywordGroceryList
        listings.keywordSdcCouponsList
        listings.keywordDealsList
      ]

      $scope.couponListings = listings.keywordCouponsList
      $scope.selectedDetail = $scope.listings.selectedDetail

      $scope.dealsListings = listings.keywordDealsList
      $scope.groceryListings = listings.keywordGroceryList
      $scope.sdcListings = listings.keywordSdcCouponsList

      ListingFilter.loading = false

      $scope.toggleDeviceNav = () ->
        $('.body-wrap').addClass('slideOutRight')

    $scope.getLogoSrc = (logo) ->
      if this.listing.slugTypeId != null
        if this.listing.logoImageFileName
          return 'http://vptst.valpak.com/img/print/' + this.listing.logoImageFileName
        else
          return '/img/defaultLogo.png'
      else
        if this.listing.logoImageFileName
          return this.listing.logoImageFileName
        else if this.listing.dealImageURL
          return this.listing.dealImageURL
        else
          return '/img/defaultLogo.png'

    $scope.getBusinessProfile = (profileId) ->
      $location.url("/listing/profile/#{profileId}")

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










