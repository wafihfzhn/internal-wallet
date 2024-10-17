module ControllerSpecHelper
  def as_user(user)
    return invalid_headers if user.nil?

    valid_headers(user.id)
  end

  def token_generator(user_id)
    "Bearer #{JsonWebToken.encode(user_id: user_id)}"
  end

  def valid_headers(user_id)
    {
      "Authorization" => token_generator(user_id),
      "Content-Type" => "application/json",
    }
  end

  def invalid_headers
    {
      "Authorization" => nil,
      "Content-Type" => "application/json",
    }
  end
end
