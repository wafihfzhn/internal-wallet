class Transaction < ApplicationRecord
  enum :transaction_type, %w[ deposit withdraw transfer ].index_by(&:itself)
  enum :status, %w[ pending success failed ].index_by(&:itself), default: :pending

  with_options presence: true do
    validates :transaction_type
    validates :status
    validates :amount
  end

  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :target_wallet, class_name: "Wallet", optional: true
end
