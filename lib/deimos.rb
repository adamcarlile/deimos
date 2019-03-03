require 'huyegger'
require 'sinatra'
require 'sinatra/contrib'
require 'webrick'
require 'logger'

require "deimos/version"

require 'deimos/logger'
require 'deimos/manager'

module Deimos
  module_function

  def boot!
    require 'deimos/status'
    Thread.new { Deimos::Status.run! }
  end

  def config
    @config ||= OpenStruct.new.tap do |x|
      x.log_level = ENV.fetch("LOG_LEVEL", ::Logger::INFO)
      x.port      = ENV.fetch("PORT", 5000)
      x.bind      = ENV.fetch("BIND_IP", "0.0.0.0")
    end
  end

  def configure
    yield(config)
  end

  def manager
    @manager ||= Deimos::Manager.new
  end

  def add(*args, &block)
    manager.add(*args, &block)
  end

  def logger
    @logger ||= Huyegger::Logger.new(::Logger.new(STDOUT).tap {|x| x.level = config.log_level})
  end
  
end
