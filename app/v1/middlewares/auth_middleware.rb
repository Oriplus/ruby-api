require_relative "../errors/jwt_error"
require_relative "../services/auth_service"

class AuthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    return @app.call(env) unless env["PATH_INFO"].include?("/products")

    token = request.env["HTTP_AUTHORIZATION"]&.split("Bearer ")&.last

    begin
      AuthService.decode(token)
      @app.call(env)
    rescue JWTError
      [401, { "content-type" => "application/json" }, ['{"error": "Unauthorized"}']]
    end
  end
end
