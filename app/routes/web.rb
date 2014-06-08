require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/param'
require 'linkedin2resume/version'
require 'linkedin2resume/logging'
require 'haml'
require 'linkedin-oauth2'
#
# Public: Front end API for the Linkedin2Resume Generator website
#
module Linkedin2Resume
  module Routes
    class Web < Sinatra::Application
      include Logging
      use Rack::Logger

      configure :development do
        set :views, 'app/views'
        set :public_folder, 'public/dist'
        set :sessions, true
        set :api, ENV['LINKEDIN_API_KEY']
        set :secret, ENV["LINKEDIN_API_SECRET"]
        set :session_secret, 'd41d8cd98f00b204e9800998ecf8427e'
        set :logging, true
      end

      # configure :production do
      #   set :views,         'app/views'
      #   set :public_folder, 'public/dist'
      #   set :sessions, true
      # end

      helpers do
        def login?
          !session[:atoken].nil?
        end

        def profile
          linkedin_client.profile unless session[:atoken].nil?
        end

        def connections
          linkedin_client.connections unless session[:atoken].nil?
        end

        private
        def linkedin_client
          client = LinkedIn::Client.new(settings.api, settings.secret, session[:atoken])
          client
        end

        def logger
          request.logger
        end

      end

      # Public: Main HTML web page to interact with app
      #
      #
      # get '/' do
      #   erb :home
      # end

      get "/" do
        logger.info "this is interesting"
        haml :index
      end

      # Public: Run API only temporarily for purposes of CLI client
      #
      #
      get "/cli/auth" do
        ENV['CLI_ONLY'] = true
        redirect "/auth"
      end

      get "/auth" do
        logger.info "Authing..."
        client = LinkedIn::Client.new(settings.api, settings.secret)
        session[:authorize_url] = client.authorize_url(redirect_uri: "http://#{request.host}:#{request.port}/auth/callback")
        redirect session[:authorize_url]
      end

      get "/auth/logout" do
        session[:atoken] = nil
        redirect "/"
      end

      get "/auth/callback" do
        code = params[:code]
        logger.info "Auth code received #{code}"
        logger.info "OK, so getting a URL to authorize and get my access token"
        client = LinkedIn::Client.new(settings.api, settings.secret)
        token = client.request_access_token(code, redirect_uri: "http://#{request.host}:#{request.port}/auth/callback")
        session[:atoken] = token.token

        # Store in env for command line!
        ENV['LINKEDIN_OAUTH2_ACCESS_TOKEN'] = token.token
        logger.info "Got access token, shutting down!: #{session[:atoken]}"

        if !ENV['CLI_ONLY'].nil?
          exit!
        end
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