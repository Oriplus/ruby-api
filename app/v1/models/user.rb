require "bcrypt"

class User
  @users = [
    {
      user_name: "admin",
      password: BCrypt::Password.create("test123"),
    },
  ]

  def self.find_by_username(user_name)
    @users.find { |user| user[:user_name] == user_name }
  end
end
