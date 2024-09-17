require 'rails_helper'

RSpec.describe TransactionService::DepositService, type: :service do
    describe "#deposit" do
        let(:wallet_addr) { "xyz12345" }
        let(:wallet) { Wallet.new(id: 1, address: wallet_addr) }
        let(:deposit_amount) { 50 }
        let(:latest_amount) { 40 }

        context "when success" do
            it "creates the deposit correctly" do
                allow(Wallet).to receive(:find_by_address).and_return(wallet)
                expect(wallet).to receive(:deposit).with(deposit_amount)
                expect(wallet).to receive(:get_balance).and_return(latest_amount)

                dep = TransactionService::DepositService.new(wallet_addr, deposit_amount)
                res = dep.deposit()
                expect(res).to eq(latest_amount)
            end
        end

        context "when wallet not found" do
            it "raises error" do
                allow(Wallet).to receive(:find_by_address).and_return(nil)

                dep = TransactionService::DepositService.new(wallet_addr, deposit_amount)
                expect { dep.deposit() }.to raise_error(ActiveRecord::RecordNotFound, I18n.t("errors.wallet_not_found"))
            end
        end

        context "when deposit model return other error" do
            let(:other_err) { "other error" }
            it "creates the deposit correctly" do
                allow(Wallet).to receive(:find_by_address).and_return(wallet)
                expect(wallet).to receive(:deposit).with(deposit_amount).and_raise(other_err)

                dep = TransactionService::DepositService.new(wallet_addr, deposit_amount)
                expect{ dep.deposit() }.to raise_error(other_err)
            end
        end
    end
end
