class ApplicationQuery
  def initialize(scope = default_scope)
    @scope = scope
  end

  def scope
    @scope.dup
  end

  def filter(options = {})
    new_repo = dup
    new_repo.send(:apply_filters, options)
    new_repo
  end

  private

  def apply_filters(options)
    options.each do |key, value|
      method = "filter_by_#{key}"
      @scope = send(method, value) || @scope if respond_to?(method, true)
    end
  end
end
