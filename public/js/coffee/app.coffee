# Declare app level module which depends on filters, and services

deps = [
  'app.filters'
  'app.services'
  'app.directives'
  'app.controllers'
  'ngResource'
  'ngCookies'
]

appConfig = ['$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
  $routeProvider
    .when '/coupons/home',
      templateUrl: '/partials/home.jade'
      controller: 'HomeController'

    .when '/coupons/query',
      templateUrl: '/partials/results.layout.jade'
      controller: 'ListingController'
      resolve:
        list: ($q) ->
          console.log('resolving...')
          d = $q.defer()
          d.resolve('REJECT!')
          return d.promise


    .when '/coupons/local-coupons/:category/:geo',
      templateUrl: '/partials/results.layout.jade'
      controller: 'ListingController'

    .when '/listing/profile/:profileId',
      templateUrl: '/partials/business_profile.jade'
      controller: 'BusinessProfileController'
      resolve:
        profile: (BusinessProfileLoader) ->
          return BusinessProfileLoader()

    .otherwise
      redirectTo: '/'

  $locationProvider.html5Mode(true).hashPrefix('!')


]


app = angular.module('app', deps)
app.config(appConfig)

app.run ['$rootScope', '$log', ($rootScope, $log) ->
  $rootScope
]
