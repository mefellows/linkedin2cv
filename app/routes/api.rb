require 'sinatra/base'
require 'eventmachine'
require 'em-websocket'
require 'sinatra/reloader'
require 'sinatra/param'
require 'linkedin-to-resume/version'
require "sinatra/json"
require "json"
require "sinatra-websocket"

#
# Public: API for the Application
#
module LinkedinToResume
  module Routes
      class API < Sinatra::Application
        include Logging
        helpers Sinatra::Param

        configure do
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

        # Public: Main API entry point to run the LinkedinToResume service
        #
        #
        get '/api/linkedin-to-resume/:uri' do

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
          log.debug("Checking ping pong for a ping: " + msg['message'])
          if (msg['message'] == 'ping')
            log.debug("Ping hit!")
            response_obj = {'message' => 'pong'}
          end
        end
    end
  end
end