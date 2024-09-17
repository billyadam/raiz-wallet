require 'rails_helper'

RSpec.describe TransactionService::WithdrawService, type: :service do
    describe "#withdraw" do
        let(:wallet_addr) { "xyz12345" }
        let(:wallet) { Wallet.new(id: 1, address: wallet_addr) }
        let(:initial_amount) { 80 }
        let(:withdraw_amount) { 50 }
        let(:latest_amount) { 30 }

        context "when success" do
            it "creates the withdrawal correctly" do
                allow(Wallet).to receive(:find_by_address).and_return(wallet)
                allow(wallet).to receive(:get_balance).and_return(initial_amount, latest_amount)
                expect(wallet).to receive(:withdraw).with(withdraw_amount)

                dep = TransactionService::WithdrawService.new(wallet_addr, withdraw_amount)
                res = dep.withdraw()
                expect(res).to eq(latest_amount)
            end
        end

        context "when balance not enough" do
            it "raises error" do
                allow(Wallet).to receive(:find_by_address).and_return(wallet)
                allow(wallet).to receive(:get_balance).and_return(40)

                dep = TransactionService::WithdrawService.new(wallet_addr, withdraw_amount)
                expect { dep.withdraw() }.to raise_error(UnprocessableError, I18n.t("errors.insufficient_balance"))
            end
        end

        context "when wallet not found" do
            it "raises error" do
                allow(Wallet).to receive(:find_by_address).and_return(nil)

                dep = TransactionService::WithdrawService.new(wallet_addr, withdraw_amount)
                expect { dep.withdraw() }.to raise_error(ActiveRecord::RecordNotFound, I18n.t("errors.wallet_not_found"))
            end
        end

        context "when model return other error" do
            let(:other_err) { "other error" }
            it "creates the withdrawal correctly" do
                allow(Wallet).to receive(:find_by_address).and_return(wallet)
                allow(wallet).to receive(:get_balance).and_return(initial_amount)
                expect(wallet).to receive(:withdraw).with(withdraw_amount).and_raise(other_err)

                dep = TransactionService::WithdrawService.new(wallet_addr, withdraw_amount)
                expect{ dep.withdraw() }.to raise_error(other_err)
            end
        end
    end
end
