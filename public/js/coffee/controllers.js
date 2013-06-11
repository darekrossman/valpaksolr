// Generated by CoffeeScript 1.6.2
(function() {
  var AppController, module;

  module = angular.module('app.controllers', []);

  AppController = module.controller('AppController', [
    '$scope', '$rootScope', '$log', 'ListingFilter', 'User', function($scope, $rootScope, $log, ListingFilter, User) {
      $scope.listingFilter = ListingFilter;
      $rootScope.$on('$routeChangeError', function(ev, current, previous, rejection) {
        return console.debug('uh oh! something went wrong!');
      });
      return $rootScope.userDetail = {
        geo: '33703'
      };
    }
  ]);

  module.controller('HomeController', ['$scope', function($scope) {}]);

  module.controller('ToolbarController', [
    '$scope', '$route', 'ListingFilter', function($scope, $route, ListingFilter) {
      $scope.layout = ListingFilter.layoutOption;
      if ($route.current.params.keywords) {
        ListingFilter.resultsLabel = "Showing results for: '" + $route.current.params.keywords + "'";
      } else {
        ListingFilter.resultsLabel = $route.current.params.category;
      }
      return $scope.setLayout = function(layout) {
        ListingFilter.layoutOption = layout;
        $scope.layout = layout;
        return localStorage.setItem('layout_option', layout);
      };
    }
  ]);

  module.controller('SearchController', [
    '$scope', '$location', '$rootScope', 'ListingFilter', function($scope, $location, $rootScope, ListingFilter) {
      return $scope.listingFilter = ListingFilter;
    }
  ]);

  module.controller('SidebarController', ['$scope', function($scope) {}]);

  module.controller('ListingController', [
    '$scope', '$location', '$route', '$rootScope', '$q', 'Coupons', 'ListingFilter', 'ScrollWatch', function($scope, $location, $route, $q, $rootScope, Coupons, ListingFilter, ScrollWatch) {
      var displayError;

      $scope.listingFilter = ListingFilter;
      $scope.listings = [];
      $scope.scrollBottomReached = false;
      $scope.listingFilter.loading = true;
      Coupons.getAllListings().then(function(listings) {
        $scope.gotError = false;
        $scope.allListings = Array.prototype.concat(listings.keywordCouponsList, listings.keywordGroceryList, listings.keywordSdcCouponsList, listings.keywordDealsList);
        $scope.appendListings();
        return $scope.listingFilter.loading = false;
      }, function(error) {
        console.debug(error);
        return displayError(error);
      });
      $scope.$on('scrollLimit', function(ev, data) {
        return $scope.scrollBottomReached = true;
      });
      $scope.getLogoSrc = function() {
        if (this.listing.slugTypeId !== null) {
          if (this.listing.logoImageFileName) {
            return 'http://www.valpak.com/img/print/' + this.listing.logoImageFileName;
          } else {
            return '/img/defaultLogo.png';
          }
        } else {
          if (this.listing.logoImageFileName) {
            return this.listing.logoImageFileName;
          } else if (this.listing.dealImageURL) {
            return this.listing.dealImageURL;
          } else {
            return '/img/defaultLogo.png';
          }
        }
      };
      $scope.appendListings = function() {
        $scope.listings = $scope.listings.concat($scope.allListings.splice(0, 20));
        return $scope.scrollBottomReached = false;
      };
      return displayError = function(error) {
        $scope.listingFilter.loading = false;
        $scope.gotError = true;
        return $scope.errorInfo = "Sorry, dawg. No can do.";
      };
    }
  ]);

  module.controller('BusinessProfileController', [
    '$scope', '$location', '$route', 'profile', function($scope, $location, $route, profile) {
      $scope.profile = profile;
      return $scope.businessGeo = profile.selectedAddressOffer.geoCoordinates;
    }
  ]);

}).call(this);

/*
//@ sourceMappingURL=controllers.map
*/
