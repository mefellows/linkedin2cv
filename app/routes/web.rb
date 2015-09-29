require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/param'
require 'haml'
require 'linkedin-oauth2'

#
# Public: Front end API for the Linkedin2CV Generator website
#
module Linkedin2CV
  module Routes
    class Web < Sinatra::Application
      # include Logging
      use Rack::Logger

      configure do
        enable :reloader        
        set :views, 'app/views'
        set :public_folder, 'public/dist'
        set :sessions, true
        set :api, ENV['LINKEDIN_API_KEY']
        set :secret, ENV["LINKEDIN_API_SECRET"]
        set :session_secret, 'd41d8cd98f00b204e9800998ecf8427e'
        set :logging, true
        set :server, 'thin'
        set :port, 5000

        # Would like to pass as option for CLI to set false, but true otherwise
        set :threaded, false # This allows sneaky thread manipulation
      end

      helpers do
        def login?
          !session[:atoken].nil?
        end

        def profile
          if session[:profile].nil?
            session[:profile] = linkedin_client.profile unless session[:atoken].nil?
          end
          session[:profile]
        end

        def connections
          linkedin_client.connections unless session[:atoken].nil?
        end

        private
        def linkedin_client
          client = LinkedIn::API.new(session[:atoken])
          client
        end

        def logger
          request.logger
        end

      end

      # Public: Home page
      #
      #
      get "/" do
        erb :home
      end

      # Public: Run API only temporarily for purposes of CLI client
      #
      #
      get "/cli/auth" do
        ENV['CLI_ONLY'] = 'true'
        redirect "/auth"
      end

      get "/auth" do
        logger.info "Authing..."
        
        LinkedIn.configure do |config|
          config.client_id     = settings.api
          config.client_secret = settings.secret
          config.scope = "r_fullprofile"
          # This must exactly match the redirect URI you set on your application's
          # settings page. If your redirect_uri is dynamic, pass it into
          # `auth_code_url` instead.
          config.redirect_uri  = "http://#{request.host}:#{request.port}/auth/callback"
        end

        # client = LinkedIn::Client.new(settings.api, settings.secret)
        client = LinkedIn::OAuth2.new

        url = client.auth_code_url({redirect_uri: "http://#{request.host}:#{request.port}/auth/callback"})
        logger.info("Auth code URL: #{url}. yfoo") 



        client = LinkedIn::OAuth2.new
        # session[:authorize_url] = client.auth_code_url(redirect_uri: "http://#{request.host}:#{request.port}/auth/callback")
        session[:authorize_url] = url
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
        
        LinkedIn.configure do |config|
          config.client_id     = settings.api
          config.client_secret = settings.secret
          config.scope = "r_fullprofile"
          # This must exactly match the redirect URI you set on your application's
          # settings page. If your redirect_uri is dynamic, pass it into
          # `auth_code_url` instead.
          config.redirect_uri  = "http://#{request.host}:#{request.port}/auth/callback"
        end        
        client = LinkedIn::OAuth2.new
        token = client.get_access_token(code) #, redirect_uri: "http://#{request.host}:#{request.port}/auth/callback")
        session[:atoken] = token.token

        # CLI Only behaviour
        if !ENV['CLI_ONLY'].nil?
          # Store in env for command line!
          file = File.new('.token', 'w')
          file.write(token.token)
          file.close

          logger.info "Got access token, shutting down!: #{session[:atoken]}"
          Thread.current.thread_variable_set('access_token', token.token)
          Thread.kill(Thread.current)
        end

        redirect "/"
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