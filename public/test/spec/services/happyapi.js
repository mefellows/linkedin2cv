'use strict';

describe('Service: linkedin2cvApi', function () {

  // load the service's module
  beforeEach(module('linkedin2cvGeneratorApp'));

  // instantiate service
  var linkedin2cvApi;
  beforeEach(inject(function (_linkedin2cvApi_) {
    linkedin2cvApi = _linkedin2cvApi_;
  }));

  it('should do something', function () {
    expect(!!linkedin2cvApi).toBe(true);
  });

});
