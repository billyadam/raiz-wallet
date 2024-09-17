class TransactionService::DepositService
    def initialize(wallet_addr, amount)
        @wallet_addr = wallet_addr
        @amount = amount
    end

    def deposit
        ActiveRecord::Base.transaction do
            wallet = Wallet.find_by_address(@wallet_addr)
            if wallet.nil?
                raise ActiveRecord::RecordNotFound, I18n.t('errors.wallet_not_found')
            end
            wallet.deposit(@amount)

            return wallet.get_balance
        end
    end
end