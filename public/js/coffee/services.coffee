# Services

angular.module('app.services', ['ngResource'])

  .factory('KeywordListings',
    ['$resource', ($resource) ->
        return $resource '/solr/listings'
    ])

  .factory('CategoryListings',
    ['$resource', ($resource) ->
        return $resource '/solr/listings/:cat', {cat: '@cat'}
    ])

  .factory('KeywordListingLoader',
    ['KeywordListings', '$q', '$location', (KeywordListings, $q, $location) ->
      return () ->
        delay = $q.defer()
        KeywordListings.get({keywords:$location.search().keywords}
          (listings) ->
            delay.resolve(listings)
          () ->
            delay.reject('Could not get listings')
          )
        return delay.promise
    ]
  )

  .factory('CategoryListingsLoader',
    ['CategoryListings', '$q', '$route', (CategoryListings, $q, $route) ->
      return () ->
        delay = $q.defer()
        CategoryListings.get({cat:$route.current.params.cat}
          (listings) ->
            delay.resolve(listings)
          () ->
            delay.reject('Could not get listings')
          )
        return delay.promise
    ]
  )

  .factory('BusinessProfile',
    ['$resource', ($resource) ->
        return $resource '/api/profile/:id', {id:'@id'}
    ]
  )

  .factory('BusinessProfileLoader',
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

  .factory('ListingFilter',
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
