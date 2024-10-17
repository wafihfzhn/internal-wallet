class ApplicationService
  def transaction(...)
    ActiveRecord::Base.transaction(...)
  end

  def assert!(falsly, on_error: "Invalid")
    raise ExceptionHandler::Invalid, on_error unless falsly
  end
end
