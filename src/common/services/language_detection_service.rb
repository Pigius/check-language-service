# frozen_string_literal: true

require 'aws-sdk-comprehend'
require 'language_list'

class LanguageDetectionService

  def initialize(text)
    @comprehend_client = Aws::Comprehend::Client.new(region: ENV['region'])
    @text = text
  end

  def call
    result = detect_dominant_language(text)
    language_detected?(result) ? build_result(result.languages[0]) : 'No result'
  end

  attr_reader :comprehend_client, :text

  private

  def language_detected?(result)
    result.languages.any?
  end

  def build_result(language_data)
    { language: build_language_name(language_data.language_code),
      language_code: language_data.language_code,
      score: language_data.score }
  end

  def build_language_name(language_code)
    LanguageList::LanguageInfo.find(language_code)&.name
  end

  def detect_dominant_language(text)
    comprehend_client.detect_dominant_language(text: text)
  end
end
