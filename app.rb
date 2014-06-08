require 'sinatra/base'
require 'sinatra/reloader'
require './app/routes/web'
require './app/routes/api'
require 'eventmachine'

#
# Public: Front end UI and API
#
module Linkedin2Resume
  EventMachine.run do
    class Linkedin2ResumeApplication < Sinatra::Application

      configure { set :server, 'thin' }
      use Rack::Deflater
      use Linkedin2Resume::Routes::API
      use Linkedin2Resume::Routes::Web

       get '/status' do
        "alive"
      end

      run!
    end
  end
end