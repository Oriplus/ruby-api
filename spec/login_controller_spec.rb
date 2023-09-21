require_relative "../app/v1/controllers/login_controller"
require_relative "../app/v1/models/user"

describe LoginController do
  let(:app) { LoginController.new(request) }

  context "#login" do
    let(:request) do
      double("Request", body: StringIO.new(body_content))
    end

    context "when provided valid credentials" do
      let(:body_content) { { user: "admin", password: "test123" }.to_json }

      it "returns a token" do
        response = app.login
        expect(response.first).to eq(200)
        expect(JSON.parse(response.last.first)["token"]).not_to be_nil
      end
    end

    context "when provided invalid credentials" do
      let(:body_content) { { user: "user2", password: "123456" }.to_json }

      it "returns an error" do
        response = app.login
        expect(response.first).to eq(422)
        expect(JSON.parse(response.last.first)["error"]).to eq("wrong user and password")
      end
    end
  end
end
