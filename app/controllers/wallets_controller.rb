class WalletsController < ApplicationController
  def deposit
    transaction = service.deposit(params[:amount])
    render_json transaction,
                TransactionOutput,
                use: :deposit_format,
                status: :created
  end

  def withdraw
    transaction = service.withdraw(params[:amount])
    render_json transaction,
                TransactionOutput,
                use: :withdraw_format,
                status: :created
  end

  def transfer
  end

  private

  def service
    WalletService.new(current_user)
  end
end
