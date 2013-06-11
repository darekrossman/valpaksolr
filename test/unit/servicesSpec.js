//'use strict';
//
///* jasmine specs for services go here */
//
//describe('service', function() {
//
//  var httpMock;
//
//  beforeEach(module('app'));
//  beforeEach(inject(function(_$httpBackend_){
//    httpMock = _$httpBackend_;
//
//    httpMock.expectGET('/user/1208095195')
//      .respond({
//        "name"        : "Darek Rossman",
//        "fbId"        : "1208095195",
//        "email"       : "",
//        "defaultGeo"  : "",
//        "joined" :    {
//                        "$date" : "2013-06-06T23:52:23.105Z"
//                      },
//        "_id" :       {
//                        "$oid" : "51b120b7a716537e16000001"
//                      },
//        "__v" : 0
//      });
//  }));
//
//  describe('User', function(){
//    it('should instatiate an empty user', inject(function(User){
//      expect(User.name).toEqual('')
//    }));
//
//    it('should find and return a user by id', inject(function(User){
//      var user = User.find('1208095195');
//      expect(user.name).toBeUndefined();
//
//      httpMock.flush();
//
//      user.then(function(_user) {
//        expect(_user.name).toEqual('Darek Rossman');
//      });
//
//    }));
//  });
//
//});
