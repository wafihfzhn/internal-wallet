module FactorySpecHelper
  def create_user(**params)
    User.create!(
      email: params.fetch(:email),
      full_name: params.fetch(:full_name, "Foo"),
      password: params.fetch(:password, "password"),
    )
  end

  def create_deposit(user, **params)
    WalletService.new(user).deposit(params.fetch(:amount, 150))
  end

  def create_withdraw(user, **params)
    WalletService.new(user).withdraw(params.fetch(:amount, 50))
  end

  def create_transfer(user, target_wallet, **params)
    WalletService.new(user).transfer(target_wallet, params.fetch(:amount, 25))
  end
end
