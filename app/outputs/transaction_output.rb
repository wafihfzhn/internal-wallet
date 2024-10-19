class TransactionOutput < ApiOutput
  def format
    {
      amount: @object.amount.to_f,
      transaction_type: @object.transaction_type,
      created_at: @object.created_at,
    }
  end

  def deposit_format
    format.merge(
      target_wallet: wallet_info(@object.target_wallet),
    )
  end

  def withdraw_format
    format.merge(
      source_wallet: wallet_info(@object.source_wallet),
    )
  end

  private

  def wallet_info(wallet)
    {
      owner_name: wallet.user.full_name,
      identifier: wallet.identifier,
      balance: wallet.balance.to_f,
    }
  end
end
