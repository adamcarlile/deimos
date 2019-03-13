module Deimos
  module Endpoints
    class Metrics < Sinatra::Application
      def initialize(registry:)
        @registry = registry
        super
      end

      disable :logging
      set :logger, Deimos.logger
      
      use Prometheus::Middleware::Exporter, registry: @registry, path: ''
      
    end
  end
end
