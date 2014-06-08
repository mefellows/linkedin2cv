require 'sinatra/base'
require 'sinatra/reloader'
require './app/routes/web'
require './app/routes/api'
require 'eventmachine'

#
# Public: Front end UI and API
#
module LinkedinToResume
  EventMachine.run do
    class LinkedinToResumeApplication < Sinatra::Application

      configure { set :server, 'thin' }
      use Rack::Deflater
      use LinkedinToResume::Routes::API
      use LinkedinToResume::Routes::Web

       get '/status' do
        "alive"
      end

      run!
    end
  end
end