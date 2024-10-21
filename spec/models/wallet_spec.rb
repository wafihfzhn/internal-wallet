require "rails_helper"

RSpec.describe Wallet do
  before do
    @zoo = create_user(email: "zoo@mail.com")
    @foo = create_user(email: "foo@mail.com")
    @zoo_wallet = @zoo.wallet
    @foo_wallet = @foo.wallet
  end

  it "succesfully create user's wallet after user creation" do
    expect(@zoo_wallet).to be_present
    expect(@foo_wallet).to be_present
  end

  it "ensure the default balance after creation" do
    expect(@zoo_wallet.balance).to be_zero
    expect(@foo_wallet.balance).to be_zero
  end


  it "validate of identifier already exists" do
    @zoo_wallet.identifier = @foo_wallet.identifier
    expect(@zoo_wallet).not_to be_valid
  end

  it "validate of nil identifier" do
    @zoo_wallet.identifier = nil
    expect(@zoo.wallet).not_to be_valid
  end

  it "validate of nil balance" do
    @zoo_wallet.balance = nil
    expect(@zoo_wallet).not_to be_valid
  end

  it "validate of nil user" do
    @zoo_wallet.user = nil
    expect(@zoo_wallet).not_to be_valid
  end
end
