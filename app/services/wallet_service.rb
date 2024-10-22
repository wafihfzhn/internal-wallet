class WalletService < ApplicationService
  def initialize(current_user)
    @current_user = current_user
    @current_wallet = current_user.wallet
  end

  def find_wallet(identifier)
    Wallet.find_by!(identifier: identifier)
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
      transaction = Transaction::Withdraw.process!(@current_wallet, amount)
      @current_wallet.decrement!(:balance, amount)

      transaction
    end
  end

  def transfer(target_wallet, amount)
    transaction do
      transaction = Transaction::Transfer.process!(@current_wallet, target_wallet, amount)
      @current_wallet.decrement!(:balance, amount)
      target_wallet.increment!(:balance, amount)

      transaction
    end
  end
end
