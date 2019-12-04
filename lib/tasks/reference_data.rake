# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
namespace :reference_data do
  desc 'create locations'
  task create_locations: :environment do
    Locations::Importer.new(NomisClient::Locations.get).call
  end

  desc 'create ethnicities'
  task create_ethnicities: :environment do
    Ethnicities::Importer.new(NomisClient::Ethnicities.get).call
  end

  desc 'create genders'
  task create_genders: :environment do
    Genders::Importer.new(NomisClient::Genders.get).call
  end

  desc 'create identifier types'
  task create_identifier_types: :environment do
    IdentifierTypes::Importer.new.call
  end

  desc 'create assessment questions'
  task create_assessment_questions: :environment do
    AssessmentQuestions::Importer.new.call
  end

  desc 'create NOMIS alert mappings'
  task create_nomis_alerts: :environment do
    NomisAlerts::Importer.new(alert_codes: NomisClient::AlertCodes.get).call
  end

  desc 'create suppliers'
  task create_suppliers: :environment do
    require 'active_record/fixtures'

    ActiveRecord::FixtureSet.create_fixtures(File.join(Rails.root, 'db/fixtures'), 'suppliers')
  end

  desc 'create locations/suppliers relationship'
  task link_suppliers: :environment do
    supplier_locations = {
      geoamey: %w[
        SRY016
        SFCUSU
        STCUSU
        SUS4
        SUS1
        SUS5
        SUS3
        SUS2
        WWM7
        WWM1
        WWM3
        WWM2
        WWM4
      ],
      serco: %w[
        CAM5
        CAM1
        CAM3
        CAM4
        CLP1
        MPS18
        MPS23
      ]
    }

    supplier_locations.each do |supplier_name, codes|
      supplier = Supplier.find_by(key: supplier_name.to_s)
      locations = codes.collect { |code| Location.find_by(nomis_agency_id: code) }.compact
      locations.each do |location|
        location.suppliers << supplier
      rescue ActiveRecord::RecordNotUnique
        puts "#{location.nomis_agency_id} <=> #{supplier_name} already exists"
      end
    end

    puts
    puts 'Summary of relationships'
    puts '========================'
    Supplier.all.each do |supplier|
      puts
      puts "Supplier #{supplier.name}:"
      supplier.locations.each do |location|
        puts " - #{location.nomis_agency_id}: #{location.title}"
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
