class TransactionOutput < ApiOutput
  def format
    {
      amount: @object.amount,
      transaction_type: @object.transaction_type,
      source: wallet_info(@object.source),
      target: wallet_info(@object.target),
      created_at: @object.created_at,
    }
  end

  private

  def wallet_info(wallet)
    return {} if wallet.nil?

    {
      owner_name: wallet.user.full_name,
      identifier: wallet.identifier,
      balance: wallet.balance,
    }
  end
end
