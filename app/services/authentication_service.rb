class AuthenticationService < ApplicationService
  def login(params)
    user = User.find_by(email: params[:email])
    is_authenticated = user&.authenticate(params[:password])
    assert! is_authenticated, on_error: "Invalid email or password"

    token = JsonWebToken.encode(user_id: user.id)
    [ user, token ]
  end
end
