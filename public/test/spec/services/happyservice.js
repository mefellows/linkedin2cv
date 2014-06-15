'use strict';

describe('Service: Linkedin2CVservice', function () {

  // load the service's module
  beforeEach(module('linkedin2cvGeneratorApp'));

  // instantiate service
  var Linkedin2CVservice;
  beforeEach(inject(function (_Linkedin2CVservice_) {
    Linkedin2CVservice = _Linkedin2CVservice_;
  }));

  it('should do something', function () {
    expect(!!Linkedin2CVservice).toBe(true);
  });

});
