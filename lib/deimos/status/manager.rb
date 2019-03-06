module Deimos
  module Status
    class Manager

      attr_reader :checks
      def checks
        @checks ||= {}
      end

      def add(name, &block)
        Deimos.logger.info "Status: Reporting #{name} status..."

        checks[name] = block || Proc.new { true }
      end

      def run!
        Deimos::Status::Runner.new(checks)
      end
    end
  end
end
