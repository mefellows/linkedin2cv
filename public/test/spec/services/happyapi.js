'use strict';

describe('Service: linkedin-to-resumeApi', function () {

  // load the service's module
  beforeEach(module('linkedin-to-resumeGeneratorApp'));

  // instantiate service
  var linkedin-to-resumeApi;
  beforeEach(inject(function (_linkedin-to-resumeApi_) {
    linkedin-to-resumeApi = _linkedin-to-resumeApi_;
  }));

  it('should do something', function () {
    expect(!!linkedin-to-resumeApi).toBe(true);
  });

});
