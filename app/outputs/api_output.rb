class ApiOutput
  def initialize(object, options = {})
    @object = object
    @options = options
  end

  def format
    @object
  end
end
