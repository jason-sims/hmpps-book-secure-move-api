# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssessmentQuestionSerializer do
  subject(:serializer) { described_class.new(assessment_question) }

  let(:assessment_question) { create :assessment_question }
  let(:result) { JSON.parse(ActiveModelSerializers::Adapter.create(serializer).to_json).deep_symbolize_keys }

  it 'contains a type property' do
    expect(result[:data][:type]).to eql 'assessment_questions'
  end

  it 'contains an id property' do
    expect(result[:data][:id]).to eql assessment_question.id
  end

  it 'contains a title attribute' do
    expect(result[:data][:attributes][:title]).to eql 'Sight Impaired'
  end

  it 'contains a category attribute' do
    expect(result[:data][:attributes][:category]).to eql 'health'
  end

  it 'contains a key attribute' do
    expect(result[:data][:attributes][:key]).to eql 'sight_impaired'
  end

  it 'contains a nomis_alert_code attribute' do
    expect(result[:data][:attributes][:nomis_alert_code]).to eql 'MSI'
  end

  it 'contains a nomis_alert_type attribute' do
    expect(result[:data][:attributes][:nomis_alert_type]).to eql 'M'
  end
end