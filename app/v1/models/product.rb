class Product
  @products = []
  @next_id = 0

  attr_reader :id, :name

  def initialize(name)
    @name = name
    @id = self.class.next_id
  end

  def serialize
    { id: @id, name: @name }
  end

  def self.all
    @products
  end

  def self.create(name)
    product = new(name)
    @products << product
  end

  def self.find(id)
    @products.find { |product| product.id == id.to_i }
  end

  def self.next_id
    @next_id += 1
  end
end
