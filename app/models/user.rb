class User < ApplicationRecord
  has_secure_password

  has_many :trips, dependent: :destroy

  validates_uniqueness_of :email

  before_save :downcase_email

  private 

  def downcase_email 
    self.email.downcase!
  end
end
