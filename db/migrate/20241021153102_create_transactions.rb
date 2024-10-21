class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :source_wallet, foreign_key: { to_table: :wallets }
      t.references :target_wallet, foreign_key: { to_table: :wallets }
      t.string :transaction_type, null: false
      t.string :status, default: "pending"
      t.decimal :amount, null: false

      t.timestamps
    end
  end
end
