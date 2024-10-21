class Wallet < ApplicationRecord
  belongs_to :user

  with_options presence: true do
    validates :identifier, uniqueness: true
    validates :balance
  end
end
