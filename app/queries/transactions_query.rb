class TransactionsQuery < ApplicationQuery
  def default_scope
    Transaction.order(created_at: :desc)
  end

  private

  def filter_by_user_wallet_id(user_wallet_id)
    @scope.where(
      "source_id = ? OR target_id = ?",
      user_wallet_id, user_wallet_id,
    )
  end

  def filter_by_transaction_type(transaction_type)
    @scope.where(transaction_type: transaction_type)
  end
end
