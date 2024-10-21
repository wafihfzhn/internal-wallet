# Matcher utama untuk memvalidasi tipe JSON
RSpec::Matchers.define :be_json_type do |expected|
  match do |actual|
    begin
      case expected
      when Array then expect(actual).to match_array_type(expected, [ "json" ])
      when Hash  then expect(actual).to match_hash_type(expected, [ "json" ])
      else raise ArgumentError, "Expected value must be an Array or Hash"
      end
    rescue RSpec::Expectations::ExpectationNotMetError => e
      store_error_message(e, actual)
      false
    end
  end

  failure_message { @message }

  def store_error_message(error, actual)
    @message = "#{error.message}\n#{JSON.pretty_generate(actual).truncate(20_000)}"
  end
end

RSpec::Matchers.define :match_array_type do |expected, path|
  match do |actual|
    begin
      validate_array_type(actual, expected, path)
    rescue RSpec::Expectations::ExpectationNotMetError => e
      @message = e.message
      false
    end
  end

  failure_message { formatted_failure_message }

  def validate_array_type(actual, expected, path)
    expect(actual).to be_an(Array)
    return expect(actual).to eq(expected) if expected.empty? || actual.empty?

    expected = normalize_array_size(expected, actual.size)
    expected.each_with_index.all? do |expected_element, index|
      validate_element(actual[index], expected_element, path + [ "[#{index}]" ])
    end
  end

  def normalize_array_size(expected, size)
    expected.length == 1 ? Array.new(size) { expected.first } : expected
  end

  def formatted_failure_message
    formatted_value = format_value(@actual_value)
    @message || "#{@element_path.join} was #{formatted_value}, expected to be #{@expected_element}"
  end
end

RSpec::Matchers.define :match_hash_type do |expected, path|
  match do |actual|
    begin
      validate_hash_type(actual, expected, path)
    rescue RSpec::Expectations::ExpectationNotMetError => e
      @message = e.message
      false
    end
  end

  failure_message { formatted_failure_message }

  def validate_hash_type(actual, expected, path)
    expect(actual).to be_a(Hash)
    return expect(actual).to eq(expected) if expected.empty? || actual.empty?

    expected.all? do |key, expected_element|
      value = actual.fetch(key) { actual[key.to_s] }
      validate_element(value, expected_element, path + [ ":#{key}" ])
    end
  end

  def formatted_failure_message
    formatted_value = format_value(@actual_value)
    @message || "#{@element_path.join} was #{formatted_value}, expected to be #{@expected_element}"
  end
end

def validate_element(actual_value, expected_element, path)
  @actual_value = actual_value
  @expected_element = expected_element
  @element_path = path

  case expected_element
  when Array  then expect(actual_value).to match_array_type(expected_element, path)
  when Hash   then expect(actual_value).to match_hash_type(expected_element, path)
  when Module then actual_value.is_a?(expected_element)
  when RSpec::Matchers::Composable then expect(actual_value).to expected_element
  when Float  then expect(actual_value).to be_within(1e-8).of(expected_element)
  else
    actual_value == expected_element
  end
end

def format_value(value)
  return "\"#{value}\"" if value.is_a?(String)
  value.nil? ? "nil" : value
end
