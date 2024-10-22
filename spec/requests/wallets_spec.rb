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

    def expect_wallet_balance
      aggregate_failures { expect(@zoo_wallet.balance).to be_zero }
    end

    it "updates the target wallet balance when amount is valid" do
      post_json "/wallets/deposit", { amount: 500 }, as_user(@foo)
      expect_response(
        :created,
        data: {
          amount: 500.0,
          transaction_type: "deposit",
          created_at: String,
          source: {},
          target: {
            owner_name: @foo.full_name,
            identifier: @foo_wallet.identifier,
            balance: 1736.47,
          },
        },
      )
    end

    it "invalid when the amount is not a number" do
      post_json "/wallets/deposit", { amount: "6523a" }, as_user(@foo)
      expect_error_response(:unprocessable_content, "Amount is not a number")
      expect_wallet_balance
    end

    it "invalid when amount is less than 1" do
      post_json "/wallets/deposit", { amount: 0 }, as_user(@zoo)
      expect_error_response(:unprocessable_content, "Amount must be greater than or equal to 1")
      expect_wallet_balance
    end

    it "invalid when unauntenticated user" do
      post_json "/wallets/deposit", { amount: 1000 }
      expect_error_response(:unauthorized, "Request unauthenticated")
      expect_wallet_balance
    end
  end

  describe "Withdraw" do
    before { @zoo_wallet.update! balance: 1499.95 }

    def expect_wallet_balance
      aggregate_failures { expect(@zoo_wallet.balance).to be(1499.95) }
    end

    it "updates the target wallet balance when amount is valid" do
      post_json "/wallets/withdraw", { amount: 500 }, as_user(@zoo)
      expect_response(
        :created,
        data: {
          amount: 500.0,
          transaction_type: "withdraw",
          created_at: String,
          target: {},
          source: {
            owner_name: @zoo.full_name,
            identifier: @zoo_wallet.identifier,
            balance: 999.95,
          },
        },
      )
    end

    it "invalid when withdrawing more than the wallet's balance" do
      post_json "/wallets/withdraw", { amount: 1500 }, as_user(@zoo)
      expect_error_response(:unprocessable_entity, "Insufficient wallet's balance")
      expect_wallet_balance
    end

    it "iinvalid when the amount is not a number" do
      post_json "/wallets/withdraw", { amount: "a1" }, as_user(@zoo)
      expect_error_response(:unprocessable_content, "Amount is not a number")
      expect_wallet_balance
    end

    it "invalid when amount is less than 1" do
      post_json "/wallets/withdraw", { amount: 0 }, as_user(@zoo)
      expect_error_response(:unprocessable_content)
      expect_wallet_balance
    end

    it "invalid when unauntenticated user" do
      post_json "/wallets/withdraw", { amount: 1000 }
      expect_error_response(:unauthorized, "Request unauthenticated")
    end
  end

  describe "Transfer" do
    before do
      @foo_wallet.update! balance: 25000.75
      @zoo_wallet.update! balance: 17450.90
    end

    def expect_wallet_balances
      aggregate_failures do
        expect(@foo_wallet.balance).to eq(25000.75)
        expect(@zoo_wallet.balance).to eq(17450.90)
      end
    end

    it "updates both sender and receiver balances correctly" do
      post_json "/wallets/#{@zoo_wallet.identifier}/transfer", { amount: 16734.54 }, as_user(@foo)
      expect_response(
        :created,
        data: {
          amount: 16734.54,
          transaction_type: "transfer",
          created_at: String,
          source: {
            owner_name: @foo.full_name,
            identifier: @foo_wallet.identifier,
            balance: 8266.21,
          },
          target: {
            owner_name: @zoo.full_name,
            identifier: @zoo_wallet.identifier,
            balance: 34185.44,
          },
        },
      )
    end

    it "invalid when sender has insufficient balance" do
      post_json "/wallets/#{@foo_wallet.identifier}/transfer", { amount: 18000 }, as_user(@zoo)
      expect_error_response(:unprocessable_content, "Insufficient wallet's balance")
      expect_wallet_balances
    end

    it "iinvalid when the amount is not a number" do
      post_json "/wallets/#{@foo_wallet.identifier}/transfer", { amount: "a1" }, as_user(@zoo)
      expect_error_response(:unprocessable_content, "Amount is not a number")
      expect_wallet_balances
    end

    it "invalid when target wallet is missing" do
      post_json "/wallets/0982731232/transfer", { amount: 1262 }, as_user(@foo)
      expect_error_response(:not_found, "Wallet not found")
      expect_wallet_balances
    end

    it "invalid when amount is less than 1" do
      post_json "/wallets/#{@foo_wallet.identifier}/transfer", { amount: 0 }, as_user(@zoo)
      expect_error_response(:unprocessable_content, "Amount must be greater than or equal to 1")
      expect_wallet_balances
    end

    it "invalid when transfer to itself" do
      post_json "/wallets/#{@foo_wallet.identifier}/transfer", { amount: 12500 }, as_user(@foo)
      expect_error_response(:unprocessable_content, "Cannot transfer to the same wallet")
      expect_wallet_balances
    end

    it "invalid when unauntenticated user" do
      post_json "/wallets/#{@foo_wallet.identifier}/transfer", { amount: 12575 }
      expect_error_response(:unauthorized, "Request unauthenticated")
    end
  end
end
