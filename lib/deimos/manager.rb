module Deimos
  class Manager

    def checks
      @checks ||= {}
    end

    def add(name, &block)
      checks[name] = block || Proc.new { true }
    end

    def call
      checks.transform_values(&:call).to_json
    end

  end
end
