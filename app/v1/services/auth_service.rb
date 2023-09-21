require "jwt"

require_relative "../errors/jwt_error"

class AuthService
  HMAC_SECRET = ENV["HMAC_SECRET"]

  def self.encode(payload)
    JWT.encode(payload, HMAC_SECRET, "HS256")
  end

  def self.decode(token)
    JWT.decode(token, HMAC_SECRET, true, { algorithm: "HS256" })[0]
  rescue JWT::DecodeError => e
    raise JWTError, e.message
  end
end
