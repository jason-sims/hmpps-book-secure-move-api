# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile::AssessmentAnswers, type: :model do
  subject(:assessment_answers) { described_class.new(data) }

  let(:title) { 'test' }
  let(:data) do
    [
      {
        title: title,
        comments: 'just a test',
        assessment_question_id: 123,
        date: Date.civil(2019, 6, 30),
        expiry_date: Date.civil(2019, 7, 30)
      },
      {
        title: title,
        comments: 'just a test',
        assessment_question_id: 456,
        date: Date.civil(2019, 5, 30),
        expiry_date: Date.civil(2019, 6, 30)
      }
    ]
  end

  describe '#to_a' do
    it 'contains correct number of items' do
      expect(assessment_answers.to_a.size).to be 2
    end

    it 'converts the items to Profile::AssessmentAnswer objects' do
      expect(assessment_answers.to_a).to all(be_a Profile::AssessmentAnswer)
    end

    context 'with an empty item' do
      subject(:assessment_answers) { described_class.new(data + [{ title: '' }]) }

      it 'strips out the empty item' do
        expect(assessment_answers.to_a.size).to be 2
      end
    end

    context 'with serialized input' do
      subject(:assessment_answers) { described_class.new(data.to_json) }

      it 'parses JSON and contains correct number of items' do
        expect(assessment_answers.to_a.size).to be 2
      end

      it 'parses JSON and converts the items to Profile::AssessmentAnswer objects' do
        expect(assessment_answers.to_a).to all(be_a Profile::AssessmentAnswer)
      end
    end
  end
end