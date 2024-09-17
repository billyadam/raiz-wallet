require 'rails_helper'

RSpec.describe TransactionService::TransferService, type: :service do
    describe "#withdraw" do
        let(:amount) { 50 }
        
        let(:src_wallet_addr) { "xyz12345" }
        let(:src_wallet) { Wallet.new(id: 1, address: src_wallet_addr) }
        let(:src_mutation) { Mutation.new(id: 11, amount: -amount)}

        let(:dest_wallet_addr) { "abc12345" }
        let(:dest_wallet) { Wallet.new(id: 2, address: dest_wallet_addr) }
        let(:dest_mutation) { Mutation.new(id: 22, amount: amount)}

        context "when success" do
            it "creates the transfer correctly" do
                allow(Wallet).to receive(:find_by_address).with(src_wallet_addr).and_return(src_wallet)
                allow(src_wallet).to receive(:get_balance).and_return(100)
                expect(src_wallet).to receive(:withdraw).with(amount).and_return(src_mutation)

                allow(Wallet).to receive(:find_by_address).with(dest_wallet_addr).and_return(dest_wallet)
                expect(dest_wallet).to receive(:deposit).with(amount).and_return(dest_mutation)

                expect(src_mutation).to receive(:update).with({related_mutation: dest_mutation}).and_return(true)
                expect(dest_mutation).to receive(:update).with({related_mutation: src_mutation}).and_return(true)
                
                dep = TransactionService::TransferService.new(src_wallet_addr, dest_wallet_addr, amount)
                dep.transfer()
            end
        end

        context "when balance not enough" do
            it "raises error" do
                allow(Wallet).to receive(:find_by_address).with(src_wallet_addr).and_return(src_wallet)
                allow(src_wallet).to receive(:get_balance).and_return(40)

                dep = TransactionService::TransferService.new(src_wallet_addr, dest_wallet_addr, amount)
                expect { dep.transfer() }.to raise_error(UnprocessableError, I18n.t("errors.insufficient_balance"))
            end
        end

        context "when source wallet not found" do
            it "raises error" do
                allow(Wallet).to receive(:find_by_address).with(src_wallet_addr).and_return(nil)

                dep = TransactionService::TransferService.new(src_wallet_addr, dest_wallet_addr, amount)
                expect { dep.transfer() }.to raise_error(ActiveRecord::RecordNotFound, I18n.t("errors.src_wallet_not_found"))
            end
        end

        context "when destination wallet not found" do
            it "raises error" do
                allow(Wallet).to receive(:find_by_address).with(src_wallet_addr).and_return(src_wallet)
                allow(src_wallet).to receive(:get_balance).and_return(100)

                allow(Wallet).to receive(:find_by_address).with(dest_wallet_addr).and_return(nil)

                dep = TransactionService::TransferService.new(src_wallet_addr, dest_wallet_addr, amount)
                expect { dep.transfer() }.to raise_error(ActiveRecord::RecordNotFound, I18n.t("errors.dest_wallet_not_found"))
            end
        end

        context "when withdraw return other error" do
            let (:other_err) { "other_error" }
            it "raises error" do
                allow(Wallet).to receive(:find_by_address).with(src_wallet_addr).and_return(src_wallet)
                allow(src_wallet).to receive(:get_balance).and_return(100)
                expect(src_wallet).to receive(:withdraw).with(amount).and_raise(StandardError, other_err)

                allow(Wallet).to receive(:find_by_address).with(dest_wallet_addr).and_return(dest_wallet)

                dep = TransactionService::TransferService.new(src_wallet_addr, dest_wallet_addr, amount)
                expect { dep.transfer() }.to raise_error(StandardError, other_err)
            end
        end

        context "when deposit return other error" do
            let (:other_err) { "other_error" }
            it "raises error" do
                allow(Wallet).to receive(:find_by_address).with(src_wallet_addr).and_return(src_wallet)
                allow(src_wallet).to receive(:get_balance).and_return(100)
                expect(src_wallet).to receive(:withdraw).with(amount).and_return(src_mutation)

                allow(Wallet).to receive(:find_by_address).with(dest_wallet_addr).and_return(dest_wallet)
                expect(dest_wallet).to receive(:deposit).with(amount).and_raise(StandardError, other_err)

                # expect(Transfer).to receive(:record_transfer).with(src_wallet, dest_wallet, amount).and_return(true)

                dep = TransactionService::TransferService.new(src_wallet_addr, dest_wallet_addr, amount)
                expect { dep.transfer() }.to raise_error(StandardError, other_err)
            end
        end
        
        context "when linking src mutation return other error" do
            let (:other_err) { "other_error" }
            it "raises error" do
                allow(Wallet).to receive(:find_by_address).with(src_wallet_addr).and_return(src_wallet)
                allow(src_wallet).to receive(:get_balance).and_return(100)
                expect(src_wallet).to receive(:withdraw).with(amount).and_return(src_mutation)

                allow(Wallet).to receive(:find_by_address).with(dest_wallet_addr).and_return(dest_wallet)
                expect(dest_wallet).to receive(:deposit).with(amount).and_return(dest_mutation)


                expect(src_mutation).to receive(:update).with({related_mutation: dest_mutation}).and_raise(StandardError, other_err)
                # expect(dest_mutation).to receive(:update).with({related_mutation: src_mutation}).and_return(true)

                dep = TransactionService::TransferService.new(src_wallet_addr, dest_wallet_addr, amount)
                expect { dep.transfer() }.to raise_error(StandardError, other_err)
            end
        end

        context "when linking dest mutation return other error" do
            let (:other_err) { "other_error" }
            it "raises error" do
                allow(Wallet).to receive(:find_by_address).with(src_wallet_addr).and_return(src_wallet)
                allow(src_wallet).to receive(:get_balance).and_return(100)
                expect(src_wallet).to receive(:withdraw).with(amount).and_return(src_mutation)

                allow(Wallet).to receive(:find_by_address).with(dest_wallet_addr).and_return(dest_wallet)
                expect(dest_wallet).to receive(:deposit).with(amount).and_return(dest_mutation)


                expect(src_mutation).to receive(:update).with({related_mutation: dest_mutation}).and_return(true)
                expect(dest_mutation).to receive(:update).with({related_mutation: src_mutation}).and_raise(StandardError, other_err)

                dep = TransactionService::TransferService.new(src_wallet_addr, dest_wallet_addr, amount)
                expect { dep.transfer() }.to raise_error(StandardError, other_err)
            end
        end
    end
end
