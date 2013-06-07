module = angular.module('app.services', ['ngResource'])




# User
#
# A user, duh
# ------------------------------------------------
module.service('User',
  ['$resource', ($resource) ->

    userResource = $resource '/user/:action/:id', {action: '@action', id: '@id'},
      create:
        method: 'POST'
        params:
          action: 'create'


    User = () ->
      this.name = ''
      this.fbId = ''
      this.email = ''
      this.loggedIn = false
      this.isAuthenticated = false
      this.defaultGeo = ''


    User.prototype.setDefaultGeo = (geo) ->
        this.defaultGeo = geo

    User.prototype.$save = () ->
      userResource.create({user: this}
        (response) ->
          console.debug(response)
        (err) ->
          console.debug('CANT CREATE USER')
      )

    User.prototype.find = (id) ->
      userResource.get({id: id}
        (_user) ->
          console.debug(_user)
        () ->
          console.debug('NO USER')
      )


    return new User()
  ])











# Keyword Listings
#
# A resource for all listings - queried by keyword
# ------------------------------------------------
module.factory('KeywordListings',
  ['$resource', ($resource) ->
      return $resource '/api/listings'
  ])

# Keyword Listings Loader
#
# Queries the KeywordListings resource for a
# given keyword parameter
# ------------------------------------------------
module.factory('KeywordListingLoader',
  ['KeywordListings', '$q', '$location', (KeywordListings, $q, $location) ->
    return (keyword) ->
      delay = $q.defer()
      KeywordListings.get({keywords:keyword}
        (listings) ->
          delay.resolve(listings)
        () ->
          delay.reject('Could not get listings')
        )
      return delay.promise
  ]
)







# Category Listings
#
# A resource for all listings - queried by category
# ------------------------------------------------
module.factory('CategoryListings',
  ['$resource', ($resource) ->
    return $resource '/api/listings/:cat', {cat: '@cat'}
  ])

# Category Listings Loader
#
# Queries the CategoryListings resource for a
# given category
# ------------------------------------------------
module.factory('CategoryListingsLoader',
  ['CategoryListings', '$q', '$route', '$location', (CategoryListings, $q, $route, $location) ->
    return (category) ->
      delay = $q.defer()
      CategoryListings.save({cat: category}
        (listings) ->
          delay.resolve(listings)
        (err) ->
          delay.reject(err)
        )
      return delay.promise
  ]
)




# Coupon Service
#
#
# ------------------------------------------------
module.service('Coupons',
  ['KeywordListingLoader', 'CategoryListingsLoader', '$q', '$route', '$location', (KeywordListingLoader, CategoryListingsLoader, $q, $route, $location) ->

    getListings = () ->
      # determine type of request (keyword | category)
      if $route.current.params.keywords
        return KeywordListingLoader($route.current.params.keywords)
      else
        return CategoryListingsLoader($route.current.params.category)

    return {
      getAllListings: getListings
    }

  ]
)





# Business Profile
#
# A resource for business profile data
# ------------------------------------------------
module.factory('BusinessProfile',
  ['$resource', ($resource) ->
      return $resource '/api/profile/:id', {id:'@id'}
  ]
)

# Business Profile Loader
#
# Queries the BusinessProfile resource for a
# dataset given a profile id
# ------------------------------------------------
module.factory('BusinessProfileLoader',
  ['BusinessProfile', '$q', '$route', (BusinessProfile, $q, $route) ->
      return () ->
        delay = $q.defer()
        BusinessProfile.get({id:$route.current.params.profileId}
          (profile) ->
            delay.resolve(profile)
          () ->
            delay.reject('Could not get profile')
        )

        return delay.promise

  ]
)






# Listing Filters
#
# Maintains client application state and UI
# options
# ------------------------------------------------
module.service('ListingFilter',
  ['$routeParams', ($routeParams) ->
    return {
      searchTerms: null
      loading: true
      searchText: ''
      activeFilters: {}
      lists:
        vpPrintable: true
        grocery: true
        deals: true
        sdc: true
      resultsLabel: ''
      slidemenuActive: true
      layoutOption: localStorage.getItem('layout_option') || 'grid'
    }
  ]
)






# Scroll Watch
#
# Broadcasts important scroll events to any
# interested parties
# ------------------------------------------------
module.factory('ScrollWatch',
  ['$rootScope', ($rootScope) ->
    scrollLimit = (el) ->
      $rootScope.$broadcast('scrollLimit', el)
    return {
      scrollLimit: scrollLimit
    }
  ]
)






# Facebook Login
#
# A service for authenticating users via Facebook
# ------------------------------------------------
module.factory('$fb',
  ['$rootScope', '$window', '$q', ($rootScope, $window, $q)->

    defer = $q.defer()

    init = () ->

      return defer.promise

    login = () ->
      loginDefer = $q.defer()
      FB.login (response) ->
        FB.api '/me?fields=id,name,picture', (user) ->
          $rootScope.$apply(
            loginDefer.resolve(user)
          )
      return loginDefer.promise

    $window.fbAsyncInit = ->

      FB.init
        appId      : '130720057130864'
        channelUrl : '//darek.io/channel.html'
        status     : true
        cookie     : true
        xfbml      : true

      FB.Event.subscribe 'auth.authResponseChange', (response) ->
#          if response.status is 'connected'
#            testAPI();
#          else if response.status is 'not_authorized'
#            FB.login()
#          else
#            FB.login()
      FB.getLoginStatus (response) ->
        if response.status is 'connected'
          console.log('user authorized, getting user')
          FB.api '/me?fields=id,name,picture', (user) ->
            $rootScope.$apply(defer.resolve(user))
        else if response.status is 'not_authorized'
          console.log('not authorized')
          defer.resolve(response)
        else
          console.log('not logged in')
          defer.resolve(response)

    ((d) ->
      id = 'facebook-jssdk'; ref = d.getElementsByTagName('script')[0]
      if d.getElementById(id)
        return
      js = d.createElement('script'); js.id = id; js.async = true;
      js.src = "//connect.facebook.net/en_US/all.js"; ref.parentNode.insertBefore(js, ref)
    )(document)

    return {
      init: init
      login: login
    }

  ]
)
