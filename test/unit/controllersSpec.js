describe( "Controllers", function () {

  var scope, ctrl, mockBackend;

  var route = {
    current: {
      params: {
        keywords: 'pizza'
      }
    }
  };

  beforeEach(module('app'));

  beforeEach(
    inject(function(_$httpBackend_, $rootScope, $controller, $location) {
      mockBackend = _$httpBackend_;
      $location.search({keywords: 'pizza'});

      mockBackend.expectGET('/solr/listings?keywords=pizza')
        .respond({listings: 'pizza'});

      mockBackend.expectGET('/partials/home.jade')
        .respond({});

      scope = $rootScope.$new();
      ctrl = $controller('ListingController', {$scope: scope, $route: route});
    })
  );

  it('should fetch data from the server', function(){
    expect(scope.couponListings).toBeUndefined();
    mockBackend.flush();
    expect(scope.listings).toBeDefined();
  });


});