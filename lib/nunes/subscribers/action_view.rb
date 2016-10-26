require "nunes/subscriber"

module Nunes
  module Subscribers
    class ActionView < ::Nunes::Subscriber
      # Private
      Pattern = /\.action_view\Z/

      # Private: The namespace for events to subscribe to.
      def self.pattern
        Pattern
      end

      def render_template(start, ending, transaction_id, payload)
        instrument_identifier :template, payload[:identifier], start, ending
      end

      def render_partial(start, ending, transaction_id, payload)
        instrument_identifier :partial, payload[:identifier], start, ending
      end

      private

      # Private: Sends timing information about identifier event.
      def instrument_identifier(kind, identifier, start, ending)
        view_path = identifier.to_s.gsub(::Rails.root.to_s, "")
        sanitised_view_path = adapter.prepare(view_path, FileSeparatorReplacement)

        if identifier
          runtime = ((ending - start) * 1_000).round
          timing "action_view.#{kind}", runtime, { :tags => ["view_path:#{sanitised_view_path}"]}
        end
      end

      # Private: What to replace file separators with.
      FileSeparatorReplacement = "_"
    end
  end
end
