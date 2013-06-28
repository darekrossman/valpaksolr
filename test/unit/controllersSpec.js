describe( "Controllers", function () {

  var scope, ctrl, mockBackend, mockListings, mockCoupons, qu;

  var $route = {
    current: {
      params: {
        keywords: 'pizza'
      }
    }
  };




  mockListings = {
    keywordCouponsList: [{businessName:'Pizza Barn'}],
    keywordGroceryList: [{}],
    keywordSdcCouponsList: [{}],
    keywordDealsList: [{}]
  };


  beforeEach(module('app'));


  beforeEach(
    inject(function($q){
      mockCoupons = {
        getAllListingsByKeyword: function(keyword) {
          qu = $q.defer()
          qu.resolve(mockListings)
          return qu.promise;
        }
      }
    })
  );


  beforeEach(
    inject(function(_$httpBackend_, $rootScope, $controller, $location) {
      mockBackend = _$httpBackend_;
      $location.path('/coupons/query?keywords=pizza&geo=33703')

      mockBackend.expectGET('/api/listings?keywords=pizza')
        .respond(mockListings);

      //mockBackend.expectGET('/partials/home.jade').respond({});

      scope = $rootScope.$new();
      ctrl = $controller('ListingController', {$scope: scope, $route: $route, Coupons: mockCoupons});
    })
  );

  it('should populate listings array', inject(function($rootScope){
    $rootScope.$apply()
    expect(scope.listings.length).toBe(4);
    expect(scope.listings[0].businessName).toBe('Pizza Barn');
  }));


});