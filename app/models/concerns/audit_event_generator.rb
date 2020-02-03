# frozen_string_literal: true

module AuditEventGenerator
  include ActiveSupport::Concern

  def self.included(base)
    base.after_commit do
      aws_client.put_events(entries: [
        {
          time: Time.zone.now,
          source: 'Event Source',
          resources: %w[EventResource],
          detail_type: 'Event Detail Type',
          detail: 'Event Detail',
          event_bus_name: 'EventBusName',
        },
      ])
    end
  end

  def aws_client
    @aws_client ||= Aws::EventBridge::Client.new(logger: Rails.logger)
  end
end
