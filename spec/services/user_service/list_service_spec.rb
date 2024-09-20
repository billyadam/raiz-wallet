require 'rails_helper'

RSpec.describe UserService::ListService, type: :service do
    describe "#wallet" do
        let(:username1) { "bono" }
        let(:name1) { "Bono" }
        let(:user1) { User.create!(name: name1, username: username1) }
        let(:address1) { "xyz123" }
        let(:wallet1) { Wallet.new(address: address1) }
        
        let(:username2) { "andi" }
        let(:name2) { "Andi" }
        let(:user2) { User.create!(name: name2, username: username2) }
        let(:address2) { "abc123" }
        let(:wallet2) { Wallet.new(address: address2) }

        let(:username3) { "jaka" }
        let(:name3) { "Jaka" }
        let(:user3) { User.create!(name: name3, username: username3) }
        let(:address3) { "pnl123" }
        let(:wallet3) { Wallet.new(address: address3) }

        it "returns data successfully" do
            allow(user1).to receive(:wallet).and_return(wallet1)
            allow(user2).to receive(:wallet).and_return(wallet2)
            allow(user3).to receive(:wallet).and_return(wallet3)

            allow(User).to receive(:all).and_return([user1, user2, user3])

            user_list_service = UserService::ListService.new()
            res = user_list_service.list()

            expect(res.length).to eq(3)

            expect(res[0][:name]).to eq(name1)
            expect(res[0][:username]).to eq(username1)
            expect(res[0][:wallet][:address]).to eq(address1)
            
            expect(res[1][:name]).to eq(name2)
            expect(res[1][:username]).to eq(username2)
            expect(res[1][:wallet][:address]).to eq(address2)

            expect(res[2][:name]).to eq(name3)
            expect(res[2][:username]).to eq(username3)
            expect(res[2][:wallet][:address]).to eq(address3)
        end
    end
end
