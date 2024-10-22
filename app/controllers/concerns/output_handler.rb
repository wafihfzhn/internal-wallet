require "pagy/extras/metadata"

module OutputHandler
  def render_json_array(model, klass = default_output, **options)
    method, status = method_and_status(options)
    pagy_data, results = pagy(model, limit: limit)
    pagination = extract_pagination(pagy_metadata(pagy_data))
    output = results.map { |result| klass.new(result, **options).send(method) }

    render json: { root_key.to_s => output.as_json, pagy_key.to_s => pagination }, status: status
  end

  def render_json(model, klass = default_output, **options)
    method, status = method_and_status(options)
    output = klass.new(model, **options).send(method)

    render json: { root_key.to_s => output.as_json }, status: status
  end

  private

  def method_and_status(options)
    [
      options.fetch(:use, :format),
      options.fetch(:status, :ok),
    ]
  end

  def extract_pagination(metadata)
    {
      count: metadata[:count],
      prev_page: metadata[:prev],
      current_page: metadata[:page],
      next_page: metadata[:next],
    }
  end

  def default_output
    ApiOutput
  end

  def pagy_key
    :pagination
  end

  def root_key
    :data
  end
end
