module OutputHandler
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

  def default_output
    ApiOutput
  end

  def root_key
    :data
  end
end
