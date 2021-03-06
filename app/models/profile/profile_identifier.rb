# frozen_string_literal: true

class Profile
  class ProfileIdentifier
    attr_accessor :identifier_type, :value

    IDENTIFIER_TYPES = %w[
      police_national_computer criminal_records_office prison_number niche_reference athena_reference
    ].freeze

    def initialize(attribute_values = {})
      attribute_values.symbolize_keys! if attribute_values.respond_to?(:symbolize_keys!)

      self.identifier_type = attribute_values[:identifier_type]
      self.value = attribute_values[:value]
    end

    def empty?
      value.blank?
    end

    def as_json
      {
        identifier_type: identifier_type,
        value: value,
      }
    end
  end
end
