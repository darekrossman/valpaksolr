describe 'Services', ->

  mockCtrl = null
  mockScope = null
  ctrl = null


  beforeEach () ->
    ctrl = angular.module('tempModule', []).controller 'DummyController', ($scope) ->
      console.log('DummyController init')

    module('app')
    module('tempModule')

  beforeEach inject ($controller, $rootScope) ->
#    mockScope = $rootScope.$new()
#    mockCtrl = $controller( 'DummyController', {$scope: mockScope} )


  describe 'Dialog', () ->

    it 'should instatiate the Dialog service', inject (Dialog) ->
      expect(Dialog).not.toBe(null)

    it 'should append/remove modal div to body', inject (Dialog) ->

      modalEl = $('body').find('.modal')

      Dialog.show('partials/business_profile.jade',
        {controller: 'DummyController'},
        {coupons: 'foo!'})
      expect( $('body').find('.modal').length ).toBe(1)



      Dialog.destroy()
      expect( $('body').find('.modal').length ).toBe(0)







