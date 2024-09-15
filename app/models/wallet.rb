class Wallet < ApplicationRecord
    has_many :mutations
    has_one :transfer_to, class_name: 'Transfer', foreign_key: 'src_wallet_id'
    has_one :transfer_from, class_name: 'Transfer', foreign_key: 'dest_wallet_id'

    def self.find_by_address(address)
        Wallet.find_by(address: address)
    end

    def get_balance
        return mutations.sum(:amount)
    end

    def withdraw(amount)
        mutations.create(amount: -amount)
    end

    def deposit(amount)
        mutations.create(amount: amount)
    end
end
