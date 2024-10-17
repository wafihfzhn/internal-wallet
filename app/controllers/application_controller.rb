class ApplicationController < ActionController::API
  include ExceptionHandler
  include OutputHandler

  private

  def current_user
    return @current_user if defined? @current_user

    @current_user ||= User.find(decoded_auth_token[:user_id])
  rescue ActiveRecord::RecordNotFound
    raise ExceptionHandler::InvalidToken, "Invalid Token"
  end

  def decoded_auth_token
    auth_token = request.authorization.to_s
                        .match(/\A\W*bearer\W+(.*)/i).to_a
                        .second

    JsonWebToken.decode(auth_token)
  end

  def logged_in?
    !!current_user
  end

  def authenticate_access!
    unless logged_in?
      raise ExceptionHandler::Unauthenticated, "Request unauthenticated"
    end
  end
end
