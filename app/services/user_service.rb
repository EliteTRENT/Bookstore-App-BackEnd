class UserService
  def self.signup(user_params)
    user = User.new(user_params)
    if user.save
      { success: true, message: "User created successfully", user: user }
    else
      { success: false, error: user.errors.full_messages }
    end
  end

  def self.login(login_params)
    user = User.find_by(email: login_params[:email])
    if user
      if user.authenticate(login_params[:password])
        token = JsonWebToken.encode({ name: user.name, email: user.email })
        { success: true, message: "Login successful", token: token }
      else
        { success: false, error: "Wrong password" }
      end
    else
      { success: false, error: "Email is not registered" }
    end
  end
end
