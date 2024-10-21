class User < ApplicationRecord
  has_secure_password

  with_options presence: true do
    validates :full_name
    validates :email, uniqueness: true
  end

  has_one :wallet
  after_create :create_wallet

  private

  def create_wallet
    identifier = SecureRandom.random_number(10**10)
    Wallet.create!(identifier: identifier, user: self)
  end
end
