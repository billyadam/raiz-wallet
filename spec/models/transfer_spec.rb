require 'rails_helper'

RSpec.describe Transfer, type: :model do
    describe ".transfer" do
        let(:src_wallet) { Wallet.new(id: 1, address: "xyz12345") }
        let(:dest_wallet) { Wallet.new(id: 2, address: "abc56789") }
        let(:amount) { 50 }

        it "creates the transfer correctly" do
            allow_any_instance_of(Transfer).to receive(:save!).and_return(true)

            trf = Transfer.transfer(src_wallet, dest_wallet, amount)
            expect(trf.src_wallet).to eq(src_wallet)
            expect(trf.dest_wallet).to eq(dest_wallet)
            expect(trf.amount).to eq(amount)
        end
    end
end
