// Generated by CoffeeScript 1.6.2
(function() {
  var module;

  module = angular.module('vp.dialogs', []);

  module.factory('Dialog', [
    '$document', '$compile', '$rootScope', '$controller', '$location', function($document, $compile, $rootScope, $controller, $location) {
      var body, defaults, destroy, modalEl, options, scope, show;

      defaults = {
        id: null,
        title: 'Default Title',
        backdrop: true,
        controller: 'BusinessProfileController',
        backdropClass: "modal-backdrop",
        footerTemplate: null,
        modalClass: "modal"
      };
      options = null;
      modalEl = null;
      scope = null;
      body = $document.find('body');
      show = function(template, options, locals) {
        var ctrl;

        options = angular.extend(options, defaults, options);
        modalEl = angular.element('<div class="' + options.modalClass + '" ng-include="\'' + template + '\'"></div>');
        scope = options.scope || $rootScope.$new();
        locals = angular.extend({
          $scope: scope,
          locals: locals
        });
        ctrl = $controller(options.controller, locals);
        modalEl.contents().data('$ngControllerController', ctrl);
        $compile(modalEl)(scope);
        body.append(modalEl);
        return $location.url('/modal');
      };
      destroy = function() {
        modalEl.remove();
        return scope.$destroy();
      };
      return {
        show: show,
        destroy: destroy
      };
    }
  ]);

}).call(this);

/*
//@ sourceMappingURL=vpDialog.map
*/