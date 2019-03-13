module Deimos
  module Metrics
    class Manager
      TYPES = {
        counter: Prometheus::Client::Counter,
        gauge: Prometheus::Client::Gauge,
        histogram: Prometheus::Client::Histogram,
        summary: Prometheus::Client::Summary
      }

      delegate :instrument, to: ActiveSupport::Notifications
      
      attr_reader :registry
      def initialize(registry: Prometheus::Client.registry)
        @registry = registry
      end

      def subscriptions
        @subscriptions ||= []
      end

      def collectors
        @collectors ||= {}
      end

      def subscribe(event_name, type:, label:, **kwargs, &block)
        Deimos.logger.info "Metrics: Subscribed to #{event_name}..."
        subscriptions << ActiveSupport::Notifications.subscribe(event_name) do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          collector = register_collector!(event_name, type, label, kwargs)
          if block_given?
            yield(event, collector)
          else
            Deimos.logger.info event
          end
        end
      end

      private

      def register_collector!(event_name, type, about, **kwargs)
        return collectors[event_name] if collectors[event_name]
        name = event_name.gsub(".", "_").to_sym
        collectors[event_name] = TYPES[type].new(name, about, kwargs).tap { |x| registry.register(x) }
      end

    end
  end
end
