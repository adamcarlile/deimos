require "sinatra/base"
require "sinatra/json"
require 'webrick'

# Sinatra Applicaiton to present basic health check endpoint
module Deimos
  class Status < Sinatra::Application

    set :bind, Deimos.config.bind
    set :port, Deimos.config.port
    disable :show_exceptions, :traps, :logging

    use Deimos::Logger

    set :quiet, true
    set :logger, Deimos.logger
    set :server, :webrick
    set :server_settings,
      Logger: Deimos.logger,
      AccessLog: []

    get "/status" do
      content_type :json
      Deimos.manager.call
    end
  end
end
