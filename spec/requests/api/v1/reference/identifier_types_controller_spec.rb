# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Reference::IdentifierTypesController do
  let(:response_json) { JSON.parse(response.body) }
  let!(:application) { create(:application) }
  let!(:token)       { create(:access_token, application: application) }

  describe 'GET /api/v1/reference/identifier_types' do
    let(:schema) { load_json_schema('get_identifier_types_responses.json') }

    let!(:identifier_types) do
      [
        create(:identifier_type),
        create(:identifier_type, :prison_number),
        create(:identifier_type, :criminal_records_office),
      ]
    end

    let(:expected_response) do
      identifier_types.map do |identifier_type|
        {
          type: 'identifier_types',
          id: identifier_type.id,
          attributes: {
            key: identifier_type.id,
            title: identifier_type.title,
            description: identifier_type.description,
          },
        }
      end
    end

    context 'when successful' do
      before do
        get '/api/v1/reference/identifier_types', params: { access_token: token.token }
      end

      it_behaves_like 'an endpoint that responds with success 200'

      it 'returns the correct data' do
        expect(response_json).to include_json(data: expected_response)
      end
    end

    context 'when not authorized', :with_client_authentication, :with_invalid_auth_headers do
      let(:detail_401) { 'Token expired or invalid' }
      let(:headers) { { 'CONTENT_TYPE': content_type }.merge(auth_headers) }
      let(:content_type) { ApiController::CONTENT_TYPE }

      before do
        get '/api/v1/reference/identifier_types', headers: headers
      end

      it_behaves_like 'an endpoint that responds with error 401'
    end

    context 'with an invalid CONTENT_TYPE header', :slow, :with_client_authentication do
      let(:content_type) { 'application/xml' }
      let(:headers) { { 'CONTENT_TYPE': content_type }.merge(auth_headers) }

      before do
        get '/api/v1/reference/identifier_types', headers: headers
      end

      it_behaves_like 'an endpoint that responds with error 415'
    end
  end
end
