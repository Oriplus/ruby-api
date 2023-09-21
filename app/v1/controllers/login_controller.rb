require_relative "../services/auth_service"

class LoginController
  def initialize(request)
    @request = request
  end

  def login
    params = JSON.parse(@request.body.read)
    user_name = params["user"]
    password = params["password"]

    if invalid_parameters?(user_name, password)
      return [422, { "content-type" => "application/json" }, ['{"error": "Invalid parameters"}']]
    end

    user = User.find_by_username(user_name)

    if user && BCrypt::Password.new(user[:password]) == password
      token = AuthService.encode({ user: user })
      [200, { "content-type" => "application/json" }, [{ token: token }.to_json]]
    else
      [422, { "content-type" => "application/json" }, ['{"error": "wrong user or password"}']]
    end
  end

  private

  def invalid_parameters?(user_name, password)
    user_name.nil? || user_name.strip.empty? || password.nil? || password.strip.empty?
  end
end
