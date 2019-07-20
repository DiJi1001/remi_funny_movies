class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  EMAIL_MAX_LENGTH = 255
  PASSWORD_MIN_LENGTH = 6

  attr_accessor :password

  validates :email, presence: true, length: { maximum: EMAIL_MAX_LENGTH }, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: PASSWORD_MIN_LENGTH }

  has_many :movies

  before_save :downcase_email_and_encrypt_password

  def right_password?(password)
    password_hash = BCrypt::Password.new(encrypted_password)
    password_hash == password
  end

  private

  def downcase_email_and_encrypt_password
    self.email = email.downcase
    self.encrypted_password = BCrypt::Password.create(password)
    self.password = nil
  end
end
