# Declare app level module which depends on filters, and services

deps = [
  'app.filters'
  'app.services'
  'app.directives'
  'app.controllers'
  'ngResource'
  'ngCookies'
  'vp.dialogs'
]

appConfig = ['$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
  $routeProvider
    .when '/coupons/home',
#      action: 'home.welcome'
      templateUrl: '/partials/home.jade'
      controller: 'HomeController'

    .when '/coupons/query',
      templateUrl: '/partials/results.layout.jade'
      controller: 'ListingController'

    .when '/coupons/local-coupons/:category/:geo',
      templateUrl: '/partials/results.layout.jade'
      controller: 'ListingController'

    .when '/listing/profile/:profileId',
      templateUrl: '/partials/business_profile.jade'
      controller: 'BusinessProfileController'

    .when '/resources/:page',
      action: ''

    .when '/modal',
      action: ''


    .otherwise
      redirectTo: '/'

  $locationProvider.html5Mode(true).hashPrefix('!')


  # intercept XHR responses
  resInterceptor = ['$rootScope', '$q', ($rootScope, $q) ->
    success = (response) ->
      return response
    error = (response) ->
      return $q.reject(response)
    return (promise) ->
      return promise.then(success, error)
  ]
  $httpProvider.responseInterceptors.push(resInterceptor)

]


app = angular.module('app', deps)

app.config(appConfig)

app.run ['$rootScope', '$log', 'User', ($rootScope, $log, User) ->

  $rootScope.debug = $log.debug

  $rootScope.$on '$routeChangeError', (ev, current, previous, rejection) ->
    $log.debug("Error: #{rejection}")


  # async load Facebook SDK
  ((d) ->
    id = 'facebook-jssdk'; ref = d.getElementsByTagName('script')[0]
    if d.getElementById(id)
      return
    js = d.createElement('script'); js.id = id; js.async = true;
    js.src = "//connect.facebook.net/en_US/all.js"; ref.parentNode.insertBefore(js, ref)
  )(document)
]
