json.user do 
  json.auth_token @token
  json.partial! 'users/user', user: @user
end
