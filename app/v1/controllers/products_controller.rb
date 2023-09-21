require "async"

class ProductsController
  def initialize(request)
    @request = request
  end

  def index
    products = Product.all.map(&:serialize)

    [200, { "content-type" => "application/json" }, [products.to_json]]
  end

  def create
    data = JSON.parse(@request.body.read)
    product_name = data["name"]

    if invalid_parameters?(product_name)
      return [422, { "content-type" => "application/json" }, ['{"error": "Invalid parameters"}']]
    end

    Async do
      sleep 5
      Product.create(product_name)
      puts "created"
    end

    [202, { "content-type" => "application/json" }, ['{"msg": "product creation iniated"}']]
  end

  def show(id)
    product = Product.find(id)

    if product
      product = product.serialize
      [200, { "content-type" => "application/json" }, [product.to_json]]
    else
      [404, { "content-type" => "application/json" }, ['{"error": "product not found"}']]
    end
  end

  private

  def invalid_parameters?(product_name)
    product_name.nil? || product_name.strip.empty?
  end
end
