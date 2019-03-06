module Deimos
  module Endpoints
    class Metrics < Sinatra::Application
      disable :logging
      set :logger, Deimos.logger
      
      use Prometheus::Middleware::Exporter, registry: Deimos.metrics.registry, path: ''
      
    end
  end
end
