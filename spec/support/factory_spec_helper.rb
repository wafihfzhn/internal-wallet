module FactorySpecHelper
  def create_user(**params)
    User.create!(
      email: params.fetch(:email),
      full_name: params.fetch(:full_name, "Foo"),
      password: params.fetch(:password, "password"),
    )
  end
end
