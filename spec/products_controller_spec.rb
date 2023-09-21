require_relative "../app/v1/controllers/products_controller"
require_relative "../app/v1/models/product"

RSpec.describe ProductsController do
  let(:app) { described_class.new(request) }

  describe "#index" do
    let(:request) { double("Request", body: "") }

    it "returns a list of products" do
      response = app.index

      expect(response.first).to eq(200)
      expect(JSON.parse(response.last.first)).to be_a(Array)
    end
  end

  describe "#create" do
    context "with valid parameters" do
      let(:product_name) { "New Product" }
      let(:request) { double("Request", body: StringIO.new({ name: "product 1" }.to_json)) }

      it "initiates product creation" do
        response = app.create

        expect(response.first).to eq(202)
        expect(JSON.parse(response.last.first)["msg"]).to eq("product creation iniated")
      end
    end

    context "with invalid parameters" do
      let(:request) { double("Request", body: StringIO.new({}.to_json)) }

      it "returns an error" do
        response = app.create

        expect(response.first).to eq(422)
        expect(JSON.parse(response.last.first)["error"]).to eq("Invalid parameters")
      end
    end
  end

  describe "#show" do
    let(:product_id) { 1 }

    let(:request) do
      double("Request", path_info: "/products/#{product_id}", body: StringIO.new)
    end

    context "when the product exists" do
      before do
        allow(Product).to receive(:find).with(product_id).and_return(double("Product", serialize: { name: "Example Product", id: product_id }))
      end

      it "returns the product details" do
        response = app.show(product_id)
        expect(response.first).to eq(200)
        parsed_response = JSON.parse(response.last.first)
        expect(parsed_response["name"]).to eq("Example Product")
        expect(parsed_response["id"]).to eq(product_id)
      end
    end

    context "when the product does not exist" do
      before do
        allow(Product).to receive(:find).with(product_id).and_return(nil)
      end

      it "returns an error" do
        response = app.show(product_id)
        expect(response.first).to eq(404)
        expect(JSON.parse(response.last.first)["error"]).to eq("product not found")
      end
    end
  end
end
