class Transaction < ApplicationRecord
  attribute :amount, :float
  enum :transaction_type, %w[ deposit withdraw transfer ].index_by(&:itself)

  with_options presence: true do
    validates :amount, numericality: { greater_than_or_equal_to: 1 }
    validates :transaction_type
  end

  belongs_to :source, class_name: "Wallet", optional: true
  belongs_to :target, class_name: "Wallet", optional: true

  class Deposit < Transaction
    def self.process!(target, amount)
      create!(target:, amount:, transaction_type: :deposit)
    end
  end

  class Withdraw < Transaction
    validates_with WithdrawValidator

    def self.process!(source, amount)
      create!(source:, amount:, transaction_type: :withdraw)
    end
  end

  class Transfer < Transaction
    validates_with TransferValidator

    def self.process!(source, target, amount)
      create!(source:, target:, amount:, transaction_type: :transfer)
    end
  end
end
