'use strict';

describe('Service: linkedin2resumeApi', function () {

  // load the service's module
  beforeEach(module('linkedin2resumeGeneratorApp'));

  // instantiate service
  var linkedin2resumeApi;
  beforeEach(inject(function (_linkedin2resumeApi_) {
    linkedin2resumeApi = _linkedin2resumeApi_;
  }));

  it('should do something', function () {
    expect(!!linkedin2resumeApi).toBe(true);
  });

});
