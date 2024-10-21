class User < ApplicationRecord
  has_secure_password

  with_options presence: true do
    validates :full_name
    validates :email, uniqueness: true
  end

  has_one :wallet
end
