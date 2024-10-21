require_relative "json_matcher_spec_helper"

module RequestSpecHelper
  # JSON Requests
  [ :get, :post ].each do |http_method|
    default_headers = { "Content-Type" => "application/json" }
    define_method("#{http_method}_json") do |path, body = {}, headers = default_headers|
      body = http_method.eql?(:get) ? body.as_json : body.to_json
      json_request(http_method, path, body, headers)
    end
  end

  def response_body
    JSON.parse(response.body, symbolize_names: true)
  end

  def response_data
    response_body[:data]
  end

  def expect_response(status, json = nil)
    begin
      expect(response).to have_http_status(status)
    rescue RSpec::Expectations::ExpectationNotMetError => e
      e.message << "\n#{JSON.pretty_generate(response_body)}"
      raise e
    end

    expect(response_body).to be_json_type(json) if json
  end

  def expect_error_response(status, message = nil)
    expect(response).to have_http_status(status)
    expect(response_body[:error][:message]).to eq(message) if message
  end

  private

  def json_request(http_method, url, body, headers)
    case http_method
    when :get then get url, params: body, headers: headers
    when :post then post url, params: body, headers: headers
    else raise ArgumentError, "Unsupported HTTP method: #{http_method}"
    end
  end
end
