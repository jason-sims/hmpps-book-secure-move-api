# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Reference::GendersController do
  let(:response_json) { JSON.parse(response.body) }
  let!(:application) { create(:application) }
  let!(:token)       { create(:access_token, application: application) }

  describe 'GET /api/v1/reference/genders' do
    let(:schema) { load_json_schema('get_genders_responses.json') }

    let(:data) do
      [
        {
          type: 'genders',
          attributes: {
            key: 'female',
            title: 'Female',
            disabled_at: nil,
          },
        },
        {
          type: 'genders',
          attributes: {
            key: 'male',
            title: 'Male',
            disabled_at: nil,
          },
        },
        {
          type: 'genders',
          attributes: {
            key: 'r',
            title: 'Refused',
            disabled_at: '2019-07-24T01:00:00+01:00',
          },
        },
      ]
    end

    before do
      data.each { |gender| Gender.create!(gender[:attributes]) }
    end

    context 'when successful' do
      before do
        get '/api/v1/reference/genders', params: { access_token: token.token }
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
        get '/api/v1/reference/genders', headers: headers
      end

      it_behaves_like 'an endpoint that responds with error 401'
    end

    context 'with an invalid CONTENT_TYPE header', :with_client_authentication, :slow do
      let(:content_type) { 'application/xml' }
      let(:headers) { { 'CONTENT_TYPE': content_type }.merge(auth_headers) }

      before do
        get '/api/v1/reference/genders', headers: headers
      end

      it_behaves_like 'an endpoint that responds with error 415'
    end
  end
end
