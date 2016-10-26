require "nunes"

module Nunes
  module Datadog
    class Adapter < ::Nunes::Adapter
      def increment(metric, options = {})
        @client.increment metric, options
      end

      def timing(metric, duration, options = {})
        @client.timing metric, value, options
      end
    end
  end
end
