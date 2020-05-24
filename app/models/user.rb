class User < ApplicationRecord
  has_secure_password

  has_many :trips, dependent: :destroy

  validates_uniqueness_of :email
end
