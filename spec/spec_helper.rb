require 'rspec'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    response_mock = File.read(__dir__ + "/mocks/profile.json")

    stub_request(:get, /.*api.linkedin.com.*/).
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.0', 'X-Li-Format'=>'json'}).
        to_return(status: 200, body: response_mock, headers: {})
  end
end

ENV['LINKEDIN_API_KEY'] = 'foo'
ENV["LINKEDIN_API_SECRET"] = 'bar'