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

  def list_format
    {
      amount: @object.amount,
      transaction_type: @object.transaction_type,
      source: wallet_info(@object.source, include_balance: false),
      target: wallet_info(@object.target, include_balance: false),
      created_at: @object.created_at,
    }
  end

  private

  def wallet_info(wallet, include_balance: true)
    return {} if wallet.nil?

    wallet_info = {
      owner_name: wallet.user.full_name,
      identifier: wallet.identifier,
    }
    wallet_info[:balance] = wallet.balance if include_balance
    wallet_info
  end
end
