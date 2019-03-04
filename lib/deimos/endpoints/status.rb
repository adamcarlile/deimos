module Deimos
  module Endpoints
    class Status < Sinatra::Application
      disable :logging
      set :logger, Deimos.logger

      get "/" do
        status_runner = Deimos.status.run!

        content_type :json
        status status_runner.status
        status_runner.body
      end
      
    end
  end
end
