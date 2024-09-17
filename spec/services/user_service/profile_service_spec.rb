require 'rails_helper'

RSpec.describe UserService::ProfileService, type: :service do
    describe "#profile" do
        let(:username) { "bono" }
        let(:name) { "Bono" }
        let(:password_raw) { "bono123" }
        let(:password_hash) { BCrypt::Password.create(password_raw) }
        let(:user) { User.create!(name: "Bono", username: username, password: password_hash) }

        let(:balance) { 4500 }
        let(:address) { "xyz123" }
        let(:wallet) { Wallet.new(address: address) }

        it "returns data successfully" do
            allow(user).to receive(:wallet).and_return(wallet)
            allow(wallet).to receive(:get_balance).and_return(balance)

            profile = UserService::ProfileService.new(user)
            res = profile.profile()
            expect(res[:name]).to eq(name)
            expect(res[:username]).to eq(username)
            expect(res[:wallet][:balance]).to eq(balance)
            expect(res[:wallet][:address]).to eq(address)
        end
    end
end
