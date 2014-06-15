require 'sinatra/base'
require 'eventmachine'
require 'em-websocket'
require 'sinatra/reloader'
require 'sinatra/param'
require "sinatra/json"
require "json"
require "sinatra-websocket"
require "linkedin2cv/converter"

#
# Public: API for the Application
#
module Linkedin2CV
  module Routes
      class API < Sinatra::Application
        helpers Sinatra::Param
        use Rack::Logger

        configure do
          set :views, 'app/views'
          set :public_folder, 'public/dist'
          set :api, ENV['LINKEDIN_API_KEY']
          set :secret, ENV["LINKEDIN_API_SECRET"]
          set :logging, true
          set :server, 'thin'
          set :port, 5000
          set :json_encoder, :to_json
          set :sockets, []
        end

        before do
          content_type :json

          # CORS ACLs
          headers 'Access-Control-Allow-Origin' => '*',
                  'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST']
        end

        # CORS pre-flight
        options '/*' do
          200
        end

        # Public: Main API entry point to run the Linkedin2CV service
        #
        #
        get '/api/cv/:name' do

          param :format, String, default: 'latex'
          param :name, String, required: true
          param :access_token, String, required: true

          logger.debug("Request received to create a CV. Format: #{params[:format]}, Name: #{params[:name]}, Token: #{params[:access_token]}")

          options = {}
          options['output_file'] = "/tmp/#{params[:name]}"
          options['format'] = params[:format]

          converter = Linkedin2CV::Converter.new(params[:access_token])
          converter.create_resume(options)

          content_type "application/pdf"
          File.read("#{options['output_file']}.pdf")
        end


        get '/socket' do
          if !request.websocket?
            JSON::generate({'data' => {}, 'error' => 'Invalid WebSocket request'})
          else
            response_obj = {'data' => {}, 'message' => 'Invalid Request'}
            request.websocket do |ws|
              ws.onopen do
                warn("socket opened")
                settings.sockets << ws
              end
              ws.onmessage do |msg|
                EM.next_tick {
                  json_msg = JSON.parse(msg)

                  # Do not remove the 'pong' response
                  # TODO: move this into an abstraction somewhere so it's hidden
                  pong = checkPong(json_msg)
                  if (!pong.nil?)
                    response_obj = pong
                  elsif

                    # Play with request/responses
                    if (json_msg['message'] == 'foo')
                      response_obj = {'message' => 'bar'}
                    else
                      # Do something with json_msg
                      response_obj = {'message' => json_msg['message']}
                    end

                  end

                  # Send a response
                  settings.sockets.each{|s| s.send(JSON::generate(response_obj)) }
                }
              end
              ws.onclose do
                warn("websocket closed")
                settings.sockets.delete(ws)
              end
            end
          end
        end

        # Public: Keep-alive check.
        #
        # Defaults to look for for a 'ping' message, responds with a 'pong'
        # Override this for custom behaviour.
        #
        def checkPong(msg)
          logger.debug("Checking ping pong for a ping: " + msg['message'])
          if (msg['message'] == 'ping')
            logger.debug("Ping hit!")
            response_obj = {'message' => 'pong'}
          end
        end
    end
  end
end