require "rails_helper"

RSpec.describe "Wallets" do
  before do
    @logan = create_user(email: "logan@mail.com", password: "logan@password")
    @iden = create_user(email: "iden@mail.com", password: "iden@password")
    @logan_wallet = @logan.wallet
    @iden_wallet = @iden.wallet
  end

  describe "Wallet Transaction Histories" do
    before do
      @logan_wallet.update! balance: 2500.79
      @iden_wallet.update! balance: 4278.53

      create_deposit(@logan, amount: 500)
      create_withdraw(@logan, amount: 1500)
      create_transfer(@logan, @iden_wallet, amount: 1000)
      create_deposit(@logan, amount: 5000)
    end

    it "returns the correct wallet transaction histories with pagination" do
      get_json "/wallets/transaction_histories", {}, as_user(@logan)
      expect_response(
        :ok,
        data: [
          {
            amount: 5000.0,
            transaction_type: "deposit",
            created_at: String,
            source: {},
            target: {
              owner_name: @logan.full_name,
              identifier: @logan_wallet.identifier,
            },
          },
          {
            amount: 1000.0,
            transaction_type: "transfer",
            created_at: String,
            source: {
              owner_name: @logan.full_name,
              identifier: @logan_wallet.identifier,
            },
            target: {
              owner_name: @iden.full_name,
              identifier: @iden_wallet.identifier,
            },
          },
          {
            amount: 1500.0,
            transaction_type: "withdraw",
            created_at: String,
            source: {
              owner_name: @logan.full_name,
              identifier: @logan_wallet.identifier,
            },
            target: {},
          },
          {
            amount: 500.0,
            transaction_type: "deposit",
            created_at: String,
            source: {},
            target: {
              owner_name: @logan.full_name,
              identifier: @logan_wallet.identifier,
            },
          },
        ],
        pagination: {
          count: 4,
          prev_page: nil,
          current_page: 1,
          next_page: nil,
        },
      )
    end

    it "returns transactions with the specified limit" do
      get_json "/wallets/transaction_histories", { limit: 2 }, as_user(@logan)
      expect_response(
        :ok,
        data: [
          {
            amount: 5000.0,
            transaction_type: "deposit",
            created_at: String,
            source: {},
            target: {
              owner_name: @logan.full_name,
              identifier: @logan_wallet.identifier,
            },
          },
          {
            amount: 1000.0,
            transaction_type: "transfer",
            created_at: String,
            source: {
              owner_name: @logan.full_name,
              identifier: @logan_wallet.identifier,
            },
            target: {
              owner_name: @iden.full_name,
              identifier: @iden_wallet.identifier,
            },
          },
        ],
        pagination: {
          count: 4,
          prev_page: nil,
          current_page: 1,
          next_page: 2,
        },
      )
    end

    it "returns the correct next page when navigating" do
      get_json "/wallets/transaction_histories", { page: 2, limit: 1 }, as_user(@logan)
      expect_response(
        :ok,
        data: [
          {
            amount: 1000.0,
            transaction_type: "transfer",
            created_at: String,
            source: {
              owner_name: @logan.full_name,
              identifier: @logan_wallet.identifier,
            },
            target: {
              owner_name: @iden.full_name,
              identifier: @iden_wallet.identifier,
            },
          },
        ],
        pagination: {
          count: 4,
          prev_page: 1,
          current_page: 2,
          next_page: 3,
        },
      )
    end

    context "When filtering transactions by type" do
      it "returns only deposit transactions" do
        get_json "/wallets/transaction_histories", { transaction_type: "deposit" }, as_user(@logan)
        expect_response(
          :ok,
          data: [
            {
              amount: 5000.0,
              transaction_type: "deposit",
              created_at: String,
              source: {},
              target: {
                owner_name: @logan.full_name,
                identifier: @logan_wallet.identifier,
              },
            },
            {
              amount: 500.0,
              transaction_type: "deposit",
              created_at: String,
              source: {},
              target: {
                owner_name: @logan.full_name,
                identifier: @logan_wallet.identifier,
              },
            },
          ],
          pagination: {
            count: 2,
            prev_page: nil,
            current_page: 1,
            next_page: nil,
          },
        )
      end

      it "returns only withdraw transactions" do
        get_json "/wallets/transaction_histories", { transaction_type: "withdraw" }, as_user(@logan)
        expect_response(
          :ok,
          data: [
            {
              amount: 1500.0,
              transaction_type: "withdraw",
              created_at: String,
              source: {
                owner_name: @logan.full_name,
                identifier: @logan_wallet.identifier,
              },
              target: {},
            },
          ],
          pagination: {
            count: 1,
            prev_page: nil,
            current_page: 1,
            next_page: nil,
          },
        )
      end

      it "returns only transfer transactions" do
        get_json "/wallets/transaction_histories", { transaction_type: "transfer" }, as_user(@logan)
        expect_response(
          :ok,
          data: [
            {
              amount: 1000.0,
              transaction_type: "transfer",
              created_at: String,
              source: {
                owner_name: @logan.full_name,
                identifier: @logan_wallet.identifier,
              },
              target: {
                owner_name: @iden.full_name,
                identifier: @iden_wallet.identifier,
              },
            },
          ],
          pagination: {
            count: 1,
            prev_page: nil,
            current_page: 1,
            next_page: nil,
          },
        )
      end
    end
  end

  describe "Deposit" do
    before { @logan_wallet.update! balance: 1236.47 }

    def expect_wallet_balance
      aggregate_failures { expect(@iden_wallet.balance).to be_zero }
    end

    it "updates the target wallet balance when amount is valid" do
      post_json "/wallets/deposit", { amount: 500 }, as_user(@logan)
      expect_response(
        :created,
        data: {
          amount: 500.0,
          transaction_type: "deposit",
          created_at: String,
          source: {},
          target: {
            owner_name: @logan.full_name,
            identifier: @logan_wallet.identifier,
            balance: 1736.47,
          },
        },
      )
    end

    it "invalid when the amount is not a number" do
      post_json "/wallets/deposit", { amount: "6523a" }, as_user(@logan)
      expect_error_response(:unprocessable_content, "Amount is not a number")
      expect_wallet_balance
    end

    it "invalid when amount is less than 1" do
      post_json "/wallets/deposit", { amount: 0 }, as_user(@iden)
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
    before { @iden_wallet.update! balance: 1499.95 }

    def expect_wallet_balance
      aggregate_failures { expect(@iden_wallet.balance).to be(1499.95) }
    end

    it "updates the source wallet balance when amount is valid" do
      post_json "/wallets/withdraw", { amount: 500 }, as_user(@iden)
      expect_response(
        :created,
        data: {
          amount: 500.0,
          transaction_type: "withdraw",
          created_at: String,
          target: {},
          source: {
            owner_name: @iden.full_name,
            identifier: @iden_wallet.identifier,
            balance: 999.95,
          },
        },
      )
    end

    it "invalid when withdrawing more than the wallet's balance" do
      post_json "/wallets/withdraw", { amount: 1500 }, as_user(@iden)
      expect_error_response(:unprocessable_entity, "Insufficient wallet's balance")
      expect_wallet_balance
    end

    it "invalid when the amount is not a number" do
      post_json "/wallets/withdraw", { amount: "a1" }, as_user(@iden)
      expect_error_response(:unprocessable_content, "Amount is not a number")
      expect_wallet_balance
    end

    it "invalid when amount is less than 1" do
      post_json "/wallets/withdraw", { amount: 0 }, as_user(@iden)
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
      @logan_wallet.update! balance: 25000.75
      @iden_wallet.update! balance: 17450.90
    end

    def expect_wallet_balances
      aggregate_failures do
        expect(@logan_wallet.balance).to eq(25000.75)
        expect(@iden_wallet.balance).to eq(17450.90)
      end
    end

    it "updates both sender and receiver balances correctly" do
      post_json "/wallets/#{@iden_wallet.identifier}/transfer", { amount: 16734.54 }, as_user(@logan)
      expect_response(
        :created,
        data: {
          amount: 16734.54,
          transaction_type: "transfer",
          created_at: String,
          source: {
            owner_name: @logan.full_name,
            identifier: @logan_wallet.identifier,
            balance: 8266.21,
          },
          target: {
            owner_name: @iden.full_name,
            identifier: @iden_wallet.identifier,
            balance: 34185.44,
          },
        },
      )
    end

    it "invalid when sender has insufficient balance" do
      post_json "/wallets/#{@logan_wallet.identifier}/transfer", { amount: 18000 }, as_user(@iden)
      expect_error_response(:unprocessable_content, "Insufficient wallet's balance")
      expect_wallet_balances
    end

    it "invalid when the amount is not a number" do
      post_json "/wallets/#{@logan_wallet.identifier}/transfer", { amount: "a1" }, as_user(@iden)
      expect_error_response(:unprocessable_content, "Amount is not a number")
      expect_wallet_balances
    end

    it "invalid when target wallet is missing" do
      post_json "/wallets/0982731232/transfer", { amount: 1262 }, as_user(@logan)
      expect_error_response(:not_found, "Wallet not found")
      expect_wallet_balances
    end

    it "invalid when amount is less than 1" do
      post_json "/wallets/#{@logan_wallet.identifier}/transfer", { amount: 0 }, as_user(@iden)
      expect_error_response(:unprocessable_content, "Amount must be greater than or equal to 1")
      expect_wallet_balances
    end

    it "invalid when transfer to itself" do
      post_json "/wallets/#{@logan_wallet.identifier}/transfer", { amount: 12500 }, as_user(@logan)
      expect_error_response(:unprocessable_content, "Cannot transfer to the same wallet")
      expect_wallet_balances
    end

    it "invalid when unauntenticated user" do
      post_json "/wallets/#{@logan_wallet.identifier}/transfer", { amount: 12575 }
      expect_error_response(:unauthorized, "Request unauthenticated")
    end
  end
end
