class Transaction < ApplicationRecord
  enum :transaction_type, %w[ deposit withdraw transfer ].index_by(&:itself)

  with_options presence: true do
    validates :amount, numericality: { greater_than_or_equal_to: 1 }
    validates :transaction_type
  end

  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :target_wallet, class_name: "Wallet", optional: true

  class Deposit < Transaction
    def self.process!(target_wallet, amount)
      create!(
        target_wallet: target_wallet,
        transaction_type: :deposit,
        amount: amount,
      )
    end
  end

  class Withdraw < Transaction
    def self.process!(source_wallet, amount)
      create!(
        source_wallet: source_wallet,
        transaction_type: :withdraw,
        amount: amount,
      )
    end
  end

  class Transfer < Transaction
  end
end
