class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :source, foreign_key: { to_table: :wallets }
      t.references :target, foreign_key: { to_table: :wallets }
      t.string :transaction_type, null: false
      t.decimal :amount, null: false

      t.timestamps
    end
  end
end
