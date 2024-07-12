class User < ApplicationRecord
  validates :name, presence: true
  validates :password, presence: true,
                       length: { in: 10..16 },  # Validates password length between 10 and 16 characters
                       format: {
                         with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?!.*(.)\1\1)[A-Za-z\d]+\z/,
                         message: "must include at least one lowercase letter, one uppercase letter, one digit, and cannot have three repeating characters in a row"
                       }
end
