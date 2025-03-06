class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def signup
    result = UserService.signup(user_params)
    if result[:success]
      render json: { message: result[:message], user: result[:user] }, status: :created
    else
      render json: { errors: result[:error] }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :mobile_number)
  end
end
