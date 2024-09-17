class TransactionService::WithdrawService
    def initialize(wallet_addr, amount)
        @wallet_addr = wallet_addr
        @amount = amount
    end

    def withdraw
        ActiveRecord::Base.transaction do
            wallet = Wallet.find_by_address(@wallet_addr)
            if wallet.nil?
                raise ActiveRecord::RecordNotFound, I18n.t('errors.wallet_not_found')
            end
            
            balance = wallet.get_balance
            if balance < @amount
                raise UnprocessableError, I18n.t('errors.insufficient_balance')
            end
        
            wallet.withdraw(@amount)
            
            return wallet.get_balance
        end
    end
end