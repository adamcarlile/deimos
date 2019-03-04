module Deimos
  module Endpoints
    class Metrics < Sinatra::Application
      disable :logging
      set :logger, Deimos.logger

      get "/" do
        content_type :json
        { status: true } 
      end
      
    end
  end
end
