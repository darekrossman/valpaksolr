module = angular.module('app.services', ['ngResource'])




# User
#
# A user, duh
# ------------------------------------------------
module.service 'User',
  ['$resource', '$q', ($resource, $q) ->


    this.username = ''
    this.email = ''
    this.geo = '33703'
    this.prefs =
      ui:
        toggles:
          listing_layout: 'list'



#    userResource = $resource '/user/:id', {id: '@id'}
#
#    return userResource



#    User.prototype.$save = () ->
#      userResource.create({user: this}
#        (response) ->
#          console.debug(response)
#        (err) ->
#          console.debug('CANT CREATE USER')
#      )
#
#    User.prototype.find = (id) ->
#      findDelay = $q.defer()
#      userResource.get({id: id}
#        (_user) ->
#          findDelay.resolve(_user)
#          console.debug(_user)
#        () ->
#          findDelay.reject('no user')
#          console.debug('NO USER')
#      )
#      return findDelay.promise
#
#
#    return new User()

    return this
  ]












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
module.factory('Facebook',
  ['$rootScope', '$window', '$q', ($rootScope, $window, $q)->

    defer = $q.defer()

    $window.fbAsyncInit = ->

      FB.init
        appId      : '130720057130864'
        channelUrl : '//darek.io/channel.html'
        status     : true
        cookie     : true
        xfbml      : true

      defer.resolve(FB)

#      FB.Event.subscribe 'auth.authResponseChange', (response) ->
##          if response.status is 'connected'
##            testAPI();
##          else if response.status is 'not_authorized'
##            FB.login()
##          else
##            FB.login()
#      FB.getLoginStatus (response) ->
#        if response.status is 'connected'
#
#          FB.api '/me?fields=id,name,picture', (user) ->
#            $rootScope.$apply(defer.resolve(user))
#
#        else if response.status is 'not_authorized'
#          defer.resolve(response)
#
#        else
#          console.log('not logged in')



    return defer.promise

  ]
)
