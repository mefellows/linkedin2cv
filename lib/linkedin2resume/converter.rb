require 'linkedin-oauth2'

module Linkedin2Resume

  class Converter


    # Public: Create a resume given a LinkedIn Profile
    #
    #
    def create_resume()

      if !ENV['LINKEDIN_OAUTH_ACCESS_TOKEN']
        require './app'
        
        # Start local API
        run Linkedin2Resume::Linkedin2ResumeApplication

        `open http://localhost:5000/`
      end

      # Get Client info based on fields provided
      # user = client.profile(:fields => %w(positions))
      # companies = user.positions.all.map { |t| t.company }


      # Find output factory/plugin (fetch from Github?)


      # Find stylist


      #
    end

  end
end
