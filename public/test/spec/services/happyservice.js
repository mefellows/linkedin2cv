'use strict';

describe('Service: Linkedin2Resumeservice', function () {

  // load the service's module
  beforeEach(module('linkedin2resumeGeneratorApp'));

  // instantiate service
  var Linkedin2Resumeservice;
  beforeEach(inject(function (_Linkedin2Resumeservice_) {
    Linkedin2Resumeservice = _Linkedin2Resumeservice_;
  }));

  it('should do something', function () {
    expect(!!Linkedin2Resumeservice).toBe(true);
  });

});
