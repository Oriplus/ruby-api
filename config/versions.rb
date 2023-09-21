SUPPORTED_VERSIONS = {
  "1" => {
    login: "/v1/users/login",
    products: %r{^/v1/products$},
    single_product: %r{^/v1/products/(\d+)$},
  },
}.freeze
