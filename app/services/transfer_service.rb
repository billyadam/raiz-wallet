class TransferService
    def initialize(src_wallet_addr, dest_wallet_addr, amount)
        @src_wallet_addr = src_wallet_addr
        @dest_wallet_addr = dest_wallet_addr
        @amount = amount
    end

    def transfer
        ActiveRecord::Base.transaction do
            src_wallet = Wallet.find_by_address(@src_wallet_addr)
            if (src_wallet.nil?)
                raise ActiveRecord::RecordNotFound, I18n.t('errors.src_wallet_not_found')
            end
            src_balance = src_wallet.get_balance()
            if src_balance < @amount
                raise UnprocessableError, I18n.t('errors.insufficient_balance')
            end

            dest_wallet = Wallet.find_by_address(@dest_wallet_addr)
            if (dest_wallet.nil?)
                raise ActiveRecord::RecordNotFound, I18n.t('errors.dest_wallet_not_found')
            end
        
            transfer = Transfer.transfer(src_wallet, dest_wallet, @amount)
        end
    end
end