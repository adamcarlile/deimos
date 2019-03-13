require 'rack'
require 'huyegger'
require 'sinatra'
require 'active_support'
require "sinatra/json"
require 'webrick'
require 'logger'
require 'webrick'
require 'concurrent-ruby'
require 'prometheus/client'
require 'prometheus/middleware/exporter'

require "deimos/version"

require 'deimos/logger'
require 'deimos/status/runner'
require 'deimos/status/manager'
require 'deimos/metrics/manager'

module Deimos
  module_function

  def boot!
    require 'deimos/endpoints/status'
    require 'deimos/endpoints/metrics'
    Thread.new do 
      ::Rack::Handler::WEBrick.run(application, {
        Host: Deimos.config.bind,
        Port: Deimos.config.port,
        Logger: Deimos.logger,
        AccessLog: []
      })
    end
  end

  def application
    Rack::Builder.new do
      Deimos.middleware.each { |m| use m }
      run Rack::URLMap.new(Deimos.applications)
    end
  end

  def config
    @config ||= OpenStruct.new.tap do |x|
      x.log_level    = ENV.fetch("LOG_LEVEL", ::Logger::INFO)
      x.port         = ENV.fetch("PORT", 5000)
      x.bind         = ENV.fetch("BIND_IP", "0.0.0.0")
      x.applications = {}
      x.middleware   = []
    end
  end

  def configure
    yield(config)
  end

  def middleware
    @middleware ||= [Rack::Deflater, Deimos::Logger] | config.middleware
  end

  def applications
    @applications ||= {
      "/status" => Deimos::Endpoints::Status.new(status: status),
      "/metrics" => Deimos::Endpoints::Metrics.new(registry: registry)
    }.merge(config.applications)
  end

  def status
    @status ||= Deimos::Status::Manager.new
  end

  def metrics
    @metrics ||= Deimos::Metrics::Manager.new
  end

  def logger
    @logger ||= Huyegger::Logger.new(::Logger.new(STDOUT).tap {|x| x.level = config.log_level})
  end

end
