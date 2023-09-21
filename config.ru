require "pry"
require "rack/deflater"
require "rack/static"
require "dotenv"
Dotenv.load

require_relative "app/routes"
require_relative "app/v1/controllers/login_controller"
require_relative "app/v1/controllers/products_controller"
require_relative "app/v1/middlewares/auth_middleware"
require_relative "app/v1/models/product"
require_relative "app/v1/models/user"

class Application
  def call(env)
    begin
      request = Rack::Request.new(env)
      routes = Routes.new(request)
      routes.route
    rescue StandardError => e
      puts e
      if e.backtrace
        file, line = e.backtrace.first.split(":")
        puts "#{file}, ln #{line}"
      end
      [500, { "content-type" => "application/json" }, ['{"error": "Unexpected error"}']]
    end
  end
end

use Rack::Static,
  :urls => ["/authors.md", "/openapi.yaml"],
  :root => "./",
  :header_rules => [
    [:all, { "cache-control" => "public, max-age=0" }],
    ["/authors.md", { "cache-control" => "public, max-age=86400" }],
  ]

use Rack::Deflater
use AuthMiddleware

run Application.new
