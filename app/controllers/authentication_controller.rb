class AuthenticationController < ApplicationController
  skip_before_action :authenticate_access!, only: :login

  def login
    user, token = service.login(params)
    render_json user, AuthOutput, use: :login_format, token: token
  end

  def auth
    render_json current_user, AuthOutput
  end

  private

  def service
    AuthenticationService.new
  end
end
