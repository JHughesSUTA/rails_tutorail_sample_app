class User < ApplicationRecord
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
end
