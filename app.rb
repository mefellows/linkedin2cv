require 'sinatra/base'
require 'sinatra/reloader'
require './app/routes/web'
require './app/routes/api'
require 'eventmachine'

#
# Public: Front end UI and API
#
module Linkedin2CV
  EventMachine.run do
    class Linkedin2CVApplication < Sinatra::Application

      configure { 
        set :server, 'thin' 
        register Sinatra::Reloader
      }
      use Rack::Deflater
      use Linkedin2CV::Routes::API
      use Linkedin2CV::Routes::Web

       get '/status' do
        "alive"
      end

      run!
    end
  end
end