# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Reference::EthnicitiesController do
  let!(:application) { create(:application) }
  let!(:token)       { create(:access_token, application: application) }
  let(:response_json) { JSON.parse(response.body) }

  describe 'GET /api/v1/reference/ethnicities' do
    let(:schema) { load_json_schema('get_ethnicities_responses.json') }

    let(:data) do
      [
        {
          type: 'ethnicities',
          attributes: {
            key: 'W1',
            title: 'White British',
            description: 'W1 - White British',
          },
        },
        {
          type: 'ethnicities',
          attributes: {
            key: 'A1',
            title: 'Asian or Asian British (Indian)',
            description: 'A1 - Asian or Asian British (Indian)',
          },
        },
      ]
    end

    before do
      data.each { |ethnicity| Ethnicity.create!(ethnicity[:attributes]) }
    end

    context 'when successful' do
      before do
        get '/api/v1/reference/ethnicities', params: { access_token: token.token }
      end

      it_behaves_like 'an endpoint that responds with success 200'

      it 'returns the correct data' do
        expect(response_json).to include_json(data: data)
      end
    end

    context 'when not authorized', :with_client_authentication, :with_invalid_auth_headers do
      let(:headers) { { 'CONTENT_TYPE': content_type }.merge(auth_headers) }
      let(:content_type) { ApiController::CONTENT_TYPE }
      let(:detail_401) { 'Token expired or invalid' }

      before do
        get '/api/v1/reference/ethnicities', headers: headers
      end

      it_behaves_like 'an endpoint that responds with error 401'
    end

    context 'with an invalid CONTENT_TYPE header', :slow, :with_client_authentication do
      let(:headers) { { 'CONTENT_TYPE': content_type }.merge(auth_headers) }
      let(:content_type) { 'application/xml' }

      before do
        get '/api/v1/reference/ethnicities', headers: headers
      end

      it_behaves_like 'an endpoint that responds with error 415'
    end
  end
end
