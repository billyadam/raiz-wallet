require 'rails_helper'

RSpec.describe UserService::WalletService, type: :service do
    describe "#wallet" do
        let(:username) { "bono" }
        let(:name) { "Bono" }
        let(:password_raw) { "bono123" }
        let(:password_hash) { BCrypt::Password.create(password_raw) }
        let(:user) { User.create!(name: "Bono", username: username, password: password_hash) }

        let(:balance) { 2500 }
        let(:address1) { "xyz123" }
        let(:address2) { "abc123" }
        let(:wallet1) { Wallet.new(address: address1) }
        let(:wallet2) { Wallet.new(address: address2) }

        let(:mut2x) { Mutation.new(amount: -5000, wallet: wallet2) }
        let(:mut4x) { Mutation.new(amount: 2000, wallet: wallet2) }

        let(:mut1) { Mutation.new(amount: 3000, wallet: wallet1) }
        let(:mut2) { Mutation.new(amount: 5000, wallet: wallet1, related_mutation: mut2x) }
        let(:mut3) { Mutation.new(amount: -1500, wallet: wallet1) }
        let(:mut4) { Mutation.new(amount: -2000, wallet: wallet1, related_mutation: mut4x) }
        
        it "returns data successfully" do
            allow(user).to receive(:wallet).and_return(wallet1)
            allow(wallet1).to receive(:get_balance).and_return(balance)

            allow(wallet1).to receive(:mutations).and_return([mut1, mut2, mut3, mut4])

            allow(mut1).to receive(:get_type).and_return("Deposit")
            allow(mut2).to receive(:get_type).and_return("Transfer In")
            allow(mut3).to receive(:get_type).and_return("Withdraw")
            allow(mut4).to receive(:get_type).and_return("Transfer Out")

            wallet_service = UserService::WalletService.new(user)
            res = wallet_service.get_wallet()
            expect(res[:address]).to eq(address1)
            expect(res[:balance]).to eq(balance)
            expect(res[:mutations].length).to eq(4)

            expect(res[:mutations][0][:time]).to eq(mut1.created_at)
            expect(res[:mutations][0][:amount]).to eq(mut1.amount)
            expect(res[:mutations][0][:type]).to eq("Deposit")

            expect(res[:mutations][1][:time]).to eq(mut2.created_at)
            expect(res[:mutations][1][:amount]).to eq(mut2.amount)
            expect(res[:mutations][1][:type]).to eq("Transfer In")
            expect(res[:mutations][1][:source_address]).to eq(mut2x.wallet.address)

            expect(res[:mutations][2][:time]).to eq(mut3.created_at)
            expect(res[:mutations][2][:amount]).to eq(mut3.amount)
            expect(res[:mutations][2][:type]).to eq("Withdraw")

            expect(res[:mutations][3][:time]).to eq(mut4.created_at)
            expect(res[:mutations][3][:amount]).to eq(mut4.amount)
            expect(res[:mutations][3][:type]).to eq("Transfer Out")
            expect(res[:mutations][3][:destination_address]).to eq(mut4x.wallet.address)
        end
    end
end
