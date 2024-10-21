require "rails_helper"

RSpec.describe "Wallets" do
  before do
    @foo = create_user(email: "foo@mail.com", password: "foo@password")
    @zoo = create_user(email: "zoo@mail.com", password: "zoo@password")
    @foo_wallet = @foo.wallet
    @zoo_wallet = @zoo.wallet
  end

  describe "Deposit" do
    before { @foo_wallet.update! balance: 1236.47 }

    it "updates the target wallet balance when amount is valid" do
      post_json "/wallets/deposit", { amount: 500 }, as_user(@foo)
      expect_response(
        :created,
        data: {
          amount: 500.0,
          transaction_type: "deposit",
          created_at: String,
          target_wallet: {
            owner_name: @foo.full_name,
            identifier: @foo_wallet.identifier,
            balance: 1736.47,
          },
        },
      )
    end

    it "invalid when amount is less than 1" do
      post_json "/wallets/deposit", { amount: 0 }, as_user(@zoo)
      expect_error_response(:unprocessable_content)
      expect(@zoo_wallet.balance).to be_zero
    end

    it "invalid when unauntenticated user" do
      post_json "/wallets/deposit", { amount: 1000 }
      expect_error_response(:unauthorized)
    end
  end

  describe "Withdraw" do
    before { @zoo_wallet.update! balance: 1499.95 }

    it "updates the target wallet balance when amount is valid" do
      post_json "/wallets/withdraw", { amount: 500 }, as_user(@zoo)
      expect_response(
        :created,
        data: {
          amount: 500.0,
          transaction_type: "withdraw",
          created_at: String,
          source_wallet: {
            owner_name: @zoo.full_name,
            identifier: @zoo_wallet.identifier,
            balance: 999.95,
          },
        },
      )
    end

    it "invalid when amount is less than 1" do
      post_json "/wallets/withdraw", { amount: 0 }, as_user(@zoo)
      expect_error_response(:unprocessable_content)
      expect(@zoo_wallet.balance.to_f).to be(1499.95)
    end

    it "invalid when withdrawing more than the available balance" do
      post_json "/wallets/withdraw", { amount: 1500 }, as_user(@zoo)
      expect_error_response(:unprocessable_entity, "Insufficient wallet's balance")
      expect(@zoo_wallet.balance.to_f).to be(1499.95)
    end

    it "invalid when unauntenticated user" do
      post_json "/wallets/withdraw", { amount: 1000 }
      expect_error_response(:unauthorized)
    end
  end
end
