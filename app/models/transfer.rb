class Transfer < ApplicationRecord
    belongs_to :src_wallet, class_name: 'Wallet'
    belongs_to :dest_wallet, class_name: 'Wallet'

    def self.transfer(src_wallet, dest_wallet, amount)
        transfer = Transfer.new
        transfer.src_wallet = src_wallet
        transfer.dest_wallet = dest_wallet
        transfer.amount = amount
        transfer.save!
        transfer
    end
end
