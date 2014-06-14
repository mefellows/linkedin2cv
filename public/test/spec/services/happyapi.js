'use strict';

describe('Service: linkedin2cv Api', function () {

  // load the service's module
  beforeEach(module('linkedin2cv GeneratorApp'));

  // instantiate service
  var linkedin2cv Api;
  beforeEach(inject(function (_linkedin2cv Api_) {
    linkedin2cv Api = _linkedin2cv Api_;
  }));

  it('should do something', function () {
    expect(!!linkedin2cv Api).toBe(true);
  });

});
