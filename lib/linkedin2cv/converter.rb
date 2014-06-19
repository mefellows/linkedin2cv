require 'linkedin-oauth2'
require 'linkedin2cv/logging'
require 'asciidoctor'
require 'launchy'
require 'tempfile'
require 'tilt'
require 'yaml'
require 'erb'
require 'net/http'


module Linkedin2CV

  class Converter
    include Logging

    API_KEY = ENV['LINKEDIN_API_KEY']
    API_SECRET = ENV["LINKEDIN_API_SECRET"]


    def initialize(token = nil)
      @display_fields = ["company", "publication", "patent", "language", "skills", "certification", "education", "course", "volunteer", "recommendations"]
      @profile_fields = ["projects:(start-date,end-date,description,id,name,url),main-address,phone-numbers,email-address,first-name,last-name,maiden-name,formatted-name,phonetic-first-name,phonetic-last-name,formatted-phonetic-name,headline,location:(name,country:(code)),industry,current-status,current-share,num-connections,num-connections-capped,summary,specialties,positions,picture-url,api-standard-profile-request:(url,headers),public-profile-url,last-modified-timestamp,proposal-comments,associations,interests,publications:(id,title,publisher:(name),authors:(id,name,person),date,url,summary),patents,languages:(id,language:(name),proficiency:(level,name)),skills:(id,skill:(name)),certifications:(id,name,authority:(name),number,start-date,end-date),educations:(id,school-name,field-of-study,start-date,end-date,degree,activities,notes),courses:(id,name,number),three-current-positions:(id,title,summary,start-date,end-date,is-current,company),three-past-positions:(id,title,summary,start-date,end-date,is-current,company),num-recommenders,recommendations-received:(id,recommendation-type,recommendation-text,recommender),mfeed-rss-url,following,job-bookmarks,suggestions,date-of-birth,member-url-resources:(url,name),related-profile-views,honors-awards"]
      @token = token

      # Confirm API keys setup
      raise StandardError, "API_KEY not set" unless !API_KEY.nil?
      raise StandardError, "API_SECRET not set" unless !API_SECRET.nil?

      # Setup default options to be merged with supplied ones

    end

    # Public: Create a resume given a LinkedIn Profile
    #
    # Takes
    def create_resume(options = {})

      # Get Profile
      profile = get_profile

      # Find stylist (LaTeX / Asciidoc etc.)
      # Find output factory/plugin (fetch from Github?)
      case options['format']
        when 'latex'
          require 'linkedin2cv/renderer/latex_renderer'

          # Currently only supports one LaTeX template
          renderer = Linkedin2CV::LatexRenderer.new
          renderer.render(profile, options)
        else
          puts "Sorry mate, I don't yet support the '#{options['format']}' format'"
        end
    end

    # Public: Authenticate & Authorize the end user (via OAuth2) and fetch access token
    #
    #
    def auth
      if @token.nil?
        # If in CLI Mode, spawn a thread, run the API and open a browser window

        thread = nil
        if !File.exists?('.token')
          auth_thread = prompt_user_authorisation

          puts "Waiting to retrieve LinkedIn OAuth token"
          sleep 1 until auth_thread.thread_variable?('access_token')
        end

        # Get Token from environment
        @token = fetch_token_from_tempfile
        puts "I have a token for you: #{@token}"
      end

      @token
    end

    # Public: Fetch Profile Data
    #
    #
    def get_profile

      # Auth
      token = auth

      # Get Client info based on fields provided
      client = LinkedIn::Client.new(API_KEY, API_SECRET, token)
      client.profile(:fields => @profile_fields)
    end

    # Public: Invoke the API and browser session for end user authentication.
    #
    # Returns a sub-process containing the API session.
    #
    def prompt_user_authorisation

      require './app/routes/web'

      # Start local API
      Launchy.open("http://localhost:5000/cli/auth")

      auth_thread = Thread.new do
        Linkedin2CV::Routes::Web.run!
      end

      auth_thread
    end

    # Public: Fetch the token from a temporary oauth token file.
    #
    #
    def fetch_token_from_tempfile
      # Store in env for command line!
      file = File.new('.token', 'r')
      token = file.read
      file.close
      token
    end
  end
end
