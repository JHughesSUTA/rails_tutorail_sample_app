class User < ApplicationRecord
  # creates an accessible attribute 
  attr_accessor :remember_token

  # change to lowercase before saving to db, for purpose of case-sensitive indeces
  before_save { self.email = email.downcase } # could be = self.email.downcase, but self is optional on the right hand side 
  # could also be: before_save {email.downcase!}

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }   # validates uniqueness, but case insensitive
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }


  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token  # if we didn't use 'self', the assignment would create a local variable callred 'remember_token'
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # returns true if given token matches the digest
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end
end