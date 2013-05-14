# Declare app level module which depends on filters, and services

angular.module('app', ['app.filters', 'app.services', 'app.directives', 'app.controllers', 'ngResource'])

  .config(['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->

    $routeProvider.when('/', {templateUrl: '/partials/home.jade', controller: 'HomeController'})

    $routeProvider.when('/search/',
      templateUrl: '/partials/results.layout.jade'
      controller: 'ListingController'
    )

    $routeProvider.when('/listings/category/:cat',
      templateUrl: '/partials/results.layout.jade'
      controller: 'ListingController'
    )

    $routeProvider.when('/listing/profile/:profileId',
      templateUrl: '/partials/business_profile.jade'
      controller: 'BusinessProfileController'
      resolve:
        profile: (BusinessProfileLoader) ->
          return BusinessProfileLoader()
    )

    $routeProvider.otherwise({redirectTo: '/'})

    $locationProvider.html5Mode(true).hashPrefix('!')
  ])
