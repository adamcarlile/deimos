module Deimos
  module Status
    class Runner
      def initialize(checks)
        @checks = checks.dup
      end

      def status
        ok? ? :ok : :internal_server_error
      end

      def body
        completed_checks.to_json
      end

      private

      def ok?
        completed_checks.values.all?
      end

      def completed_checks
        @completed_checks ||= @checks.transform_values do |function|
          Concurrent::Promises.future(&function)
        end.transform_values(&:value)
      end
      
    end
  end
end