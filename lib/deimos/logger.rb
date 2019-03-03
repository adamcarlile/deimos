# frozen_string_literal: true

require 'rack/body_proxy'

module Deimos
  class Logger

    def initialize(app, logger = Deimos.logger)
      @app = app
      @logger = logger
    end

    def call(env)
      began_at = Rack::Utils.clock_time
      status, header, body = @app.call(env)
      header = Rack::Utils::HeaderHash.new(header)
      body = Rack::BodyProxy.new(body) { log(env, status, header, began_at) }
      [status, header, body]
    end

    private

    def log(env, status, header, began_at)
      @logger.info({
        message: [env[Rack::REQUEST_METHOD], env[Rack::PATH_INFO]].join(' '),
        remote_ip: env['HTTP_X_FORWARDED_FOR'] || env["REMOTE_ADDR"],
        status: status.to_s[0..3],
        duration: (Rack::Utils.clock_time - began_at).round(4)
      })
    end
  end
end