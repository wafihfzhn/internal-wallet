class JsonWebToken
  HMAC_SECRET = ENV.fetch("SECRET_KEY_BASE")

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    body = JWT.decode(token, HMAC_SECRET)[0]
    ActiveSupport::HashWithIndifferentAccess.new body
  rescue JWT::DecodeError
    raise ExceptionHandler::Invalid, "Invalid token"
  end
end
