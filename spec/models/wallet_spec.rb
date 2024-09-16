require 'rails_helper'

RSpec.describe Wallet, type: :model do
    let(:password) { BCrypt::Password.create("password123")}
    let(:user) { User.create!(name: "Johnny", username: "johnny", password: password) }

    let(:wallet) { Wallet.create!(user: user, address: "xyz", id: 10) }

    before do
        wallet.mutations.create!(amount: 100)
        wallet.mutations.create!(amount: 200)
        wallet.mutations.create!(amount: -50)
    end

    describe '.find_by_address' do
        it 'returns the wallet with the given address' do
            expect(Wallet).to receive(:find_by).with(address: "xyz").and_return(wallet)
            res = Wallet.find_by_address("xyz")
            expect(res).to eq(wallet)
        end
    end

    describe '#get_balance' do
        it 'return the sum of all mutations' do
            res = wallet.get_balance
            expect(res).to eq(250)
        end
    end

    describe '#withdraw' do
        it 'adds a new withdraw' do
            wallet.withdraw(40)
            expect(wallet.mutations.count).to eq(4)
            expect(wallet.mutations.last.amount).to eq(-40)
        end
    end

    describe '#deposit' do
        it 'adds a new withdraw' do
            wallet.deposit(40)
            expect(wallet.mutations.count).to eq(4)
            expect(wallet.mutations.last.amount).to eq(40)
        end
    end
end
