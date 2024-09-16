require 'rails_helper'

RSpec.describe TransactionService::DepositService, type: :service do
    describe "#deposit" do
        let(:wallet_addr) { "xyz12345" }
        let(:wallet) { Wallet.new(id: 1, address: wallet_addr) }
        let(:amount) { 50 }

        context "when success" do
            it "creates the deposit correctly" do
                allow(Wallet).to receive(:find_by_address).and_return(wallet)
                expect(wallet).to receive(:deposit).with(amount)

                dep = TransactionService::DepositService.new(wallet_addr, amount)
                dep.deposit()
            end
        end

        context "when wallet not found" do
            it "raises error" do
                allow(Wallet).to receive(:find_by_address).and_return(nil)

                dep = TransactionService::DepositService.new(wallet_addr, amount)
                expect { dep.deposit() }.to raise_error(ActiveRecord::RecordNotFound, I18n.t("errors.wallet_not_found"))
            end
        end

        context "when deposit model return other error" do
            let(:other_err) { "other error" }
            it "creates the deposit correctly" do
                allow(Wallet).to receive(:find_by_address).and_return(wallet)
                expect(wallet).to receive(:deposit).with(amount).and_raise(other_err)

                dep = TransactionService::DepositService.new(wallet_addr, amount)
                expect{ dep.deposit() }.to raise_error(other_err)
            end
        end
    end
end
