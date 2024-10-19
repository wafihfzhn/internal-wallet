class WalletService < ApplicationService
  def initialize(current_user)
    super()
    @current_user = current_user
    @current_wallet = current_user.wallet
  end

  def deposit(amount)
    transaction do
      transaction = Transaction::Deposit.process!(@current_wallet, amount)
      @current_wallet.increment!(:balance, amount)

      transaction
    end
  end

  def withdraw(amount)
    transaction do
      not_insufficient_balance = @current_wallet.balance >= amount
      assert! not_insufficient_balance, on_error: "Insufficient wallet's balance"

      transaction = Transaction::Withdraw.process!(@current_wallet, amount)
      @current_wallet.decrement!(:balance, amount)

      transaction
    end
  end
end
