# frozen_string_literal: true

require_relative '../../common/services/language_detection_service'

def run(event:, context:)
  puts event
  body = transform_body(event['body'])
  text = body[:text]

  return 'missing text' if text.nil?

  check_text_language(text)
end

def check_text_language(text)
  response = LanguageDetectionService.new(text).call
  { statusCode: 200, body: JSON.generate(body: response) }
rescue => error
  { statusCode: 500, body: JSON.generate(errors: error) }
end

def transform_body(body)
  JSON.parse(body).transform_keys(&:to_sym)
end
