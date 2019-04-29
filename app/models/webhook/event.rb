module Webhook
  class Event
    EVENT_TYPES = %w(
      entry_created
      entry_updated
      entry_destroyed
    ).freeze

    attr_reader :event_name, :payload

    def initialize(event_name, payload = {})
      @event_name = event_name
      @payload = payload
    end

    def as_json(*args)
      hash = payload.transform_values do |value|
        serialize_resource(value)
      end

      hash[:event_name] = event_name
      hash
    end

    private

    def serialize_resource(resource)
      case resource.class.name.to_s.downcase
      when 'entry'
        EntrySerializer.new(resource).serialized_json
      end
    end
  end
end