'use strict';

describe('Service: LinkedinToResumeservice', function () {

  // load the service's module
  beforeEach(module('linkedin-to-resumeGeneratorApp'));

  // instantiate service
  var LinkedinToResumeservice;
  beforeEach(inject(function (_LinkedinToResumeservice_) {
    LinkedinToResumeservice = _LinkedinToResumeservice_;
  }));

  it('should do something', function () {
    expect(!!LinkedinToResumeservice).toBe(true);
  });

});
