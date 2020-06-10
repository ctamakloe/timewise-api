
 class AuthenticationController < ApplicationController
   skip_before_action :authenticate_request

   def authenticate
     command = AuthenticateUser.call(params[:email], params[:password])

     if command.success?
       @token = command.result
       @user = User.find_by_email(params[:email].try(:downcase))

       # render json: { auth_token: command.result }
     else
       render json: { error: command.errors }, status: :unauthorized
     end
   end
 end

