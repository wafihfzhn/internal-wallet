class ApplicationController < ActionController::API
  include ExceptionHandler
  include OutputHandler

  before_action :authenticate_access!

  private

  def query_params
    request.query_parameters.symbolize_keys
  end

  def current_user
    @current_user ||= User.find(decoded_auth_token[:user_id])
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    return request.authorization.to_s.split.second if request.authorization

    raise ExceptionHandler::Unauthenticated, "Request unauthenticated"
  end

  def authenticate_access!
    !!current_user
  end
end
