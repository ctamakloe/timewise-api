class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: :create

  # POST /users
  def create
    @user = User.new(user_params)

    render json: { error: 'Failed to create user' }, status: :not_acceptable unless @user.save 

    @token = JsonWebToken.encode(user_id: @user.id)
    # render json: { token: @token }, status: :created
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
