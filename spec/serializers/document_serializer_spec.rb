# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DocumentSerializer do
  subject(:serializer) { described_class.new(document) }

  let(:document) { create :document }
  let(:result) { JSON.parse(ActiveModelSerializers::Adapter.create(serializer).to_json).deep_symbolize_keys }
  let(:result_data) { result[:data] }
  let(:attributes) { result_data[:attributes] }

  it 'contains a type property' do
    expect(result_data[:type]).to eql 'documents'
  end

  it 'contains and `id` property' do
    expect(result_data[:id]).to eql document.id
  end

  it 'contains a `filename` attribute' do
    expect(attributes[:filename]).to eql 'file-sample_100kB.doc'
  end

  it 'contains a `filesize` attribute' do
    expect(attributes[:filesize]).to be 100352
  end

  it 'contains a `content_type` attribute' do
    expect(attributes[:content_type]).to eql 'application/msword'
  end
end
