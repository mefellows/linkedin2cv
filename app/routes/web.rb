require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/param'
require 'linkedin-to-resume/version'
require 'linkedin-to-resume/logging'

#
# Public: Front end API for the LinkedinToResume Generator website
#
module LinkedinToResume
  module Routes
    class Web < Sinatra::Application
      include Logging

      configure :development, :test do
        set :views,         'app/views'
        set :public_folder, 'public/dist'
      end

      configure :production do
        set :views,         'app/views'
        set :public_folder, 'public/dist'
      end

      # Public: Main HTML web page to interact with app
      #
      #
      get '/' do
        erb :home
      end

      #
      # Public: 404 page
      #
      not_found do
        'This is nowhere to be found.'
      end

      #
      # Public: Error page
      #
      error do
        'Im sorry, <a href="http://github.com/mefellows/">this guy</a>" wrote some shit code and hasnt improved it yet. He did say this was experimental though!'
      end

    end
  end
end