'use strict';

/* jasmine specs for filters go here */

describe('filter', function() {

  var titleCase;

  beforeEach(module('app'));
  beforeEach(inject(function($filter){
    titleCase = $filter('titleCase');
  }));

  describe('titleCase', function() {
    it('should title case a string', function() {
      expect( titleCase('I AM ALL CAPS.') ).toEqual('I Am All Caps.');
    });
  });

});
