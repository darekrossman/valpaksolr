# Declare app level module which depends on filters, and services

deps = [
  'app.filters'
  'app.services'
  'app.directives'
  'app.controllers'
  'ngResource'
]

appConfig = ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider
    .when '/',
      templateUrl: '/partials/home.jade'
      controller: 'HomeController'

    .when '/search/',
      templateUrl: '/partials/results.layout.jade'
      controller: 'ListingController'

    .when '/listings/category/:cat',
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

