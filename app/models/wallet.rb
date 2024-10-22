class Wallet < ApplicationRecord
  attribute :balance, :float

  with_options presence: true do
    validates :identifier, uniqueness: true
    validates :balance
  end

  belongs_to :user
end
