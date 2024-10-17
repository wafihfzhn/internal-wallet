class AuthenticationController < ApplicationController
  def login
    user, token = service.login(params)
    render_json user, AuthOutput, token: token
  end

  private

  def service
    AuthenticationService.new
  end
end
