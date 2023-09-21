require_relative "../config/versions"

class Routes
  def initialize(request)
    @request = request
  end

  def route
    version = get_version
    return not_found unless valid_version?(version)

    case
    when @request.path == SUPPORTED_VERSIONS[version][:login]
      controller(LoginController).login
    when @request.path.match(SUPPORTED_VERSIONS[version][:products])
      @request.get? ? controller(ProductsController).index : controller(ProductsController).create
    when matched = @request.path.match(SUPPORTED_VERSIONS[version][:single_product])
      product_id = matched.captures.first
      @request.get? ? controller(ProductsController).show(product_id) : not_found
    else
      not_found
    end
  end

  private

  def controller(klass)
    klass.new(@request)
  end

  def get_version
    match_data = @request.path.match(%r{^/v(\d+)})
    match_data&.captures&.first
  end

  def not_found
    [404, { "content-type" => "application/json" }, ["Not Found"]]
  end

  def valid_version?(version)
    ["1"].include?(version)
  end
end
