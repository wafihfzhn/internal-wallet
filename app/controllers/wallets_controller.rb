class WalletsController < ApplicationController
  def histories
    transaction_histories = service.histories(query_params)
    render_json_array transaction_histories,
                      TransactionOutput,
                      use: :list_format
  end

  def deposit
    transaction = service.deposit(params[:amount])
    render_json transaction, TransactionOutput, status: :created
  end

  def withdraw
    transaction = service.withdraw(params[:amount])
    render_json transaction, TransactionOutput, status: :created
  end

  def transfer
    target_wallet = service.find_wallet(params[:identifier])
    transaction = service.transfer(target_wallet, params[:amount])
    render_json transaction, TransactionOutput, status: :created
  end

  private

  def service
    WalletService.new(current_user)
  end
end
