class UserService
  def self.signup(user_params)
    user = User.new(user_params)
    if user.save
      { success: true, message: "User created successfully", user: user }
    else
      { success: false, error: user.errors.full_messages }
    end
  end
end
