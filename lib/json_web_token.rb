class JsonWebToken
 class << self
   def encode(payload, exp = 24.hours.from_now)
     payload[:exp] = exp.to_i
     secret = Rails.application.secrets.secret_key_base || ENV['SECRET_KEY_BASE']
     JWT.encode(payload, secret)
     # JWT.encode(payload, Rails.application.secrets.secret_key_base)
   end

   def decode(token)
     secret = Rails.application.secrets.secret_key_base || ENV['SECRET_KEY_BASE']
     body = JWT.decode(token, secret)[0]
     # body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
     HashWithIndifferentAccess.new body
   rescue
     nil
   end
 end
end
